group "default" {
  targets = ["standalone", "fastcgi"]
}

target "standalone" {
  context = "./4"
  dockerfile = "Dockerfile"
  tags = ["serverb/adminer:latest", "serverb/adminer:4.13"]
  platforms = ["linux/amd64", "linux/386"]
  
}

target "fastcgi" {
  context = "./4/fastcgi"
  dockerfile = "Dockerfile"
  tags = ["serverb/adminer:fastcgi", "serverb/adminer:4.13-fastcgi"]
  platforms = ["linux/amd64", "linux/386"]
}