terraform{
    required_providers{
        google={
            source="hashicorp/google"
            version="3.47.0"
        }
        kubernetes={
            source="hashicorp/kubernetes"
            version="2.6.1"
        }
    }
    required_version = "~> 1"
}