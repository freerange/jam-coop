#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from 'aws-cdk-lib';
import { MusicCoopStack } from '../lib/music-coop-stack';

const AWS_ACCOUNT_ID = '746135554472'
const AWS_REGION = 'us-west-2'

const app = new cdk.App();

new MusicCoopStack(app, 'MusicCoopProductionStack', {
  env: { account: AWS_ACCOUNT_ID, region: AWS_REGION },
  s3Username: 'music-coop-s3-user-production',
  s3BucketName: 'music-coop-production',
  cdnDomainName: 'cdn.jam.coop',
  cdnOriginDomainName: 'jam.coop'
});

new MusicCoopStack(app, 'MusicCoopDevelopmentStack', {
  env: { account: AWS_ACCOUNT_ID, region: AWS_REGION },
  s3Username: 'music-coop-s3-user-development',
  s3BucketName: 'music-coop-development',
  cdnDomainName: 'cdn-dev.jam.coop',
  cdnOriginDomainName: 'dev.jam.coop'
});
