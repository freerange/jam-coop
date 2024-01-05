import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as iam from 'aws-cdk-lib/aws-iam';
import * as cloudfront from 'aws-cdk-lib/aws-cloudfront';
import * as origins from 'aws-cdk-lib/aws-cloudfront-origins';
import * as acm from 'aws-cdk-lib/aws-certificatemanager';

interface MusicCoopStackProps extends cdk.StackProps {
  readonly s3Username: string;
  readonly s3BucketName: string;
  readonly cdnCertificate: acm.Certificate;
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
      userName: s3User.userName,
      status: iam.AccessKeyStatus.INACTIVE
    });

    const s3UserNewAccessKey = new iam.CfnAccessKey(this, 's3UserNewCfnAccessKey', {
      userName: s3User.userName,
      serial: 1
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
      },
      cors: [{
        allowedMethods: [s3.HttpMethods.PUT],
        allowedOrigins: [`https://${props.cdnOriginDomainName}`],
        allowedHeaders: ['Content-Type', 'Content-MD5', 'Content-Disposition'],
        exposedHeaders: [],
        maxAge: 3600,
      }],
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
      certificate: props.cdnCertificate
    });

    new cdk.CfnOutput(this, 's3UserAccessKey', {
      value: s3UserAccessKey.ref,
    });

    new cdk.CfnOutput(this, 's3UserSecretAccessKey', {
      value: s3UserAccessKey.attrSecretAccessKey,
    });

    new cdk.CfnOutput(this, 's3UserNewAccessKey', {
      value: s3UserNewAccessKey.ref,
    });

    new cdk.CfnOutput(this, 's3UserNewSecretAccessKey', {
      value: s3UserNewAccessKey.attrSecretAccessKey,
    });

    new cdk.CfnOutput(this, 'cdnDistributionDomainName', {
      value: cdnDistribution.distributionDomainName
    });
  }
}
