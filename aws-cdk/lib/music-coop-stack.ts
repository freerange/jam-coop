import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as iam from 'aws-cdk-lib/aws-iam';
import * as cloudfront from 'aws-cdk-lib/aws-cloudfront';
import * as origins from 'aws-cdk-lib/aws-cloudfront-origins';

interface MusicCoopStackProps extends cdk.StackProps {
  readonly s3Username: string;
  readonly s3BucketName: string;
  readonly cdnDomainName: string;
  readonly cdnOriginDomainName: string;
}

export class MusicCoopStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props: MusicCoopStackProps) {
    super(scope, id, props);

    const s3User = new iam.User(this, 's3User', {
      userName: props.s3Username
    });

    const s3UserAccessKey = new iam.CfnAccessKey(this, 's3UserCfnAccessKey', {
      userName: s3User.userName
    });

    const s3Bucket = new s3.Bucket(this, 's3Bucket', {
      bucketName: props.s3BucketName,
      objectOwnership: s3.ObjectOwnership.BUCKET_OWNER_PREFERRED,
      publicReadAccess: true,
      blockPublicAccess: {
        blockPublicAcls: false,
        blockPublicPolicy: false,
        ignorePublicAcls: false,
        restrictPublicBuckets: false,
      }
    });

    s3Bucket.grantRead(s3User);
    s3Bucket.grantPut(s3User);
    s3Bucket.grantPutAcl(s3User);
    s3Bucket.grantDelete(s3User);

    const cdnDistribution = new cloudfront.Distribution(this, 'cdnDistribution', {
      defaultBehavior: {
        origin: new origins.HttpOrigin(props.cdnOriginDomainName, {
          protocolPolicy: cloudfront.OriginProtocolPolicy.HTTPS_ONLY
        })
      },
      domainNames: [props.cdnDomainName],
    });

    new cdk.CfnOutput(this, 's3UserAccessKey', {
      value: s3UserAccessKey.ref,
    });

    new cdk.CfnOutput(this, 's3UserSecretAccessKey', {
      value: s3UserAccessKey.attrSecretAccessKey,
    });

    new cdk.CfnOutput(this, 'cdnDistributionDomainName', {
      value: cdnDistribution.distributionDomainName
    });
  }
}
