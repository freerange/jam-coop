#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from 'aws-cdk-lib';
import { CertificateStack } from '../lib/certificate-stack';
import { MusicCoopStack } from '../lib/music-coop-stack';

const AWS_ACCOUNT_ID = '746135554472'
const AWS_REGION = 'us-west-2'
const AWS_REGION_FOR_CERTIFICATES = 'us-east-1'

const app = new cdk.App();

const certificateProductionStack = new CertificateStack(app, 'CertificateProductionStack', {
  env: { account: AWS_ACCOUNT_ID, region: AWS_REGION_FOR_CERTIFICATES },
  crossRegionReferences: true,
  domainName: 'cdn.jam.coop',
});

new MusicCoopStack(app, 'MusicCoopProductionStack', {
  env: { account: AWS_ACCOUNT_ID, region: AWS_REGION },
  crossRegionReferences: true,
  cdnBucketName: 'music-coop-cdn-production',
  cdnCertificate: certificateProductionStack.certificate,
});

const certificateDevelopmentStack = new CertificateStack(app, 'CertificateDevelopmentStack', {
  env: { account: AWS_ACCOUNT_ID, region: AWS_REGION_FOR_CERTIFICATES },
  crossRegionReferences: true,
  domainName: 'cdn-dev.jam.coop',
});

new MusicCoopStack(app, 'MusicCoopDevelopmentStack', {
  env: { account: AWS_ACCOUNT_ID, region: AWS_REGION },
  crossRegionReferences: true,
  cdnBucketName: 'music-coop-cdn-development',
  cdnCertificate: certificateDevelopmentStack.certificate,
});
