import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as s3 from 'aws-cdk-lib/aws-s3';

interface MusicCoopStackProps extends cdk.StackProps {
  readonly s3BucketName: string;
}

export class MusicCoopStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props: MusicCoopStackProps) {
    super(scope, id, props);

    new s3.Bucket(this, 's3Bucket', {
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
  }
}
