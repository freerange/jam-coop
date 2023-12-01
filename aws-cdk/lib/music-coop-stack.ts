import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as cloudfront from 'aws-cdk-lib/aws-cloudfront';

interface MusicCoopStackProps extends cdk.StackProps {
  readonly cdnBucketName: string;
}

export class MusicCoopStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props: MusicCoopStackProps) {
    super(scope, id, props);

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

    const cdnDistribution = new cloudfront.CloudFrontWebDistribution(this, 'cdnDistribution', {
      originConfigs: [
        {
          s3OriginSource: { s3BucketSource: cdnBucket },
          behaviors : [{ isDefaultBehavior: true }],
        },
      ],
    });

    new cdk.CfnOutput(this, 'cdnDistributionDomainName', {
      value: cdnDistribution.distributionDomainName
    });
  }
}
