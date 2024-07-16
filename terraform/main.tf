provider "aws"{
    region = var.region_name
}

module "static_content_s3"{
    source = "./modules/S3"

    s3_bucket_name = var.s3_static_bucket_name
}