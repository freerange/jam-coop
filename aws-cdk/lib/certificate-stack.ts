import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as acm from 'aws-cdk-lib/aws-certificatemanager';

interface CertificateStackProps extends cdk.StackProps {
  readonly domainName: string;
}

export class CertificateStack extends cdk.Stack {
  certificate: acm.Certificate;

  constructor(scope: Construct, id: string, props: CertificateStackProps) {
    super(scope, id, props);

    this.certificate = new acm.Certificate(this, 'certificate', {
      domainName: props.domainName,
      validation: acm.CertificateValidation.fromDns(),
    });
  }
}
