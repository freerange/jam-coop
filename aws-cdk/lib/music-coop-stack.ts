import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as cloudfront from 'aws-cdk-lib/aws-cloudfront';
import * as origins from 'aws-cdk-lib/aws-cloudfront-origins';
import * as iam from 'aws-cdk-lib/aws-iam';
import * as acm from 'aws-cdk-lib/aws-certificatemanager';

interface MusicCoopStackProps extends cdk.StackProps {
  readonly cdnUsername: string;
  readonly cdnBucketName: string;
  readonly cdnDomainName: string;
  readonly cdnCertificate: acm.Certificate;
  readonly originDomainName: string;
}

export class MusicCoopStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props: MusicCoopStackProps) {
    super(scope, id, props);

    const cdnUser = new iam.User(this, 'cdnUser', {
      userName: props.cdnUsername
    });

    const cdnUserAccessKey = new iam.CfnAccessKey(this, 'cdnUserCfnAccessKey', {
      userName: cdnUser.userName
    });

    const cdnBucket = new s3.Bucket(this, 'cdnBucket', {
      bucketName: props.cdnBucketName,
      publicReadAccess: true,
      blockPublicAccess: {
        blockPublicAcls: false,
        blockPublicPolicy: false,
        ignorePublicAcls: false,
        restrictPublicBuckets: false,
      }
    });

    cdnBucket.grantRead(cdnUser);
    cdnBucket.grantPut(cdnUser);
    cdnBucket.grantDelete(cdnUser);

    const cdnDistribution = new cloudfront.Distribution(this, 'cdnDistribution', {
      defaultBehavior: {
        origin: new origins.HttpOrigin(props.originDomainName, {
          protocolPolicy: cloudfront.OriginProtocolPolicy.HTTPS_ONLY
        })
      },
      domainNames: [props.cdnDomainName],
      certificate: props.cdnCertificate,
    });

    new cdk.CfnOutput(this, 'cdnUserAccessKey', {
      value: cdnUserAccessKey.ref,
    });

    new cdk.CfnOutput(this, 'cdnUserSecretAccessKey', {
      value: cdnUserAccessKey.attrSecretAccessKey,
    });

    new cdk.CfnOutput(this, 'cdnDistributionDomainName', {
      value: cdnDistribution.distributionDomainName
    });
  }
}
