import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as acm from 'aws-cdk-lib/aws-certificatemanager';
import * as cloudfront from 'aws-cdk-lib/aws-cloudfront';

interface CertificateStackProps extends cdk.StackProps {
  readonly domainName: string;
}

export class CertificateStack extends cdk.Stack {
  certificate: cloudfront.ViewerCertificate;

  constructor(scope: Construct, id: string, props: CertificateStackProps) {
    super(scope, id, props);

    this.certificate = cloudfront.ViewerCertificate.fromAcmCertificate(
      new acm.Certificate(this, 'certificate', {
        domainName: props.domainName,
        validation: acm.CertificateValidation.fromDns(),
      }),
      { aliases: [props.domainName] }
    );
  }
}
