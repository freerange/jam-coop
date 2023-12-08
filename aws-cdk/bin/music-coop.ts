#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from 'aws-cdk-lib';
import { MusicCoopStack } from '../lib/music-coop-stack';

const AWS_ACCOUNT_ID = '746135554472'
const AWS_REGION = 'us-west-2'

const app = new cdk.App();

const CDN_DOMAIN_NAME_PRODUCTION = 'cdn.jam.coop';
const CDN_ORIGIN_DOMAIN_NAME_PRODUCTION = 'jam.coop';

new MusicCoopStack(app, 'MusicCoopProductionStack', {
  env: { account: AWS_ACCOUNT_ID, region: AWS_REGION },
  s3Username: 'music-coop-s3-user-production',
  s3BucketName: 'music-coop-production',
  cdnDomainName: CDN_DOMAIN_NAME_PRODUCTION,
  cdnOriginDomainName: CDN_ORIGIN_DOMAIN_NAME_PRODUCTION,
});

const CDN_DOMAIN_NAME_DEVELOPMENT = 'cdn-dev.jam.coop';
const CDN_ORIGIN_DOMAIN_NAME_DEVELOPMENT = 'dev.jam.coop';

new MusicCoopStack(app, 'MusicCoopDevelopmentStack', {
  env: { account: AWS_ACCOUNT_ID, region: AWS_REGION },
  s3Username: 'music-coop-s3-user-development',
  s3BucketName: 'music-coop-development',
  cdnDomainName: CDN_DOMAIN_NAME_DEVELOPMENT,
  cdnOriginDomainName: CDN_ORIGIN_DOMAIN_NAME_DEVELOPMENT
});
