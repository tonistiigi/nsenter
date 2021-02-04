variable "NSENTER_REPO" {
    default = "tonistiigi/nsenter"
}

variable "NSENTER_VERSION" {
    default = "v2.36"
}

variable "NSENTER_VERSION_ONLY" {
    default = ""
}

group "default" {
    targets = ["binaries"]
}

target "image" {
    args = {
        NSENTER_VERSION: "${NSENTER_VERSION}"
    }
    tags = [
        "${NSENTER_REPO}:${NSENTER_VERSION}",
        "${NSENTER_VERSION_ONLY}"=="true"?"":"${NSENTER_REPO}"
    ]
}

target "binaries" {
    inherits = ["image"]
    output = ["type=local"]
    platforms = ["local"]
}

target "_all_platforms" {
    platforms = ["linux/amd64", "linux/arm64", "linux/arm", "linux/386"]
}

target "image-all" {
    inherits = ["image", "_all_platforms"]
}

target "binaries-all" {
    inherits = ["image", "_all_platforms"]
}
