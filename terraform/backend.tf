terraform { 
    required_version = ">=0.12.0"
    required_providers { aws = ">=3.0.0" } 
    backend "s3" {
        region = "us-west-2"
        profile = "default"
        key = "terraformstatefile"
        bucket = "balamanohar-2019ht66529-wilp-bits-2021"
        }
}

