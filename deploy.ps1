 $REGISTRY = "192.168.11.119:32000"
$APP = "hola-edge"

$VERSION = Get-Date -Format "yyyyMMddHHmmss"

Write-Host ""
Write-Host "==============================="
Write-Host "DEPLOY VERSION $VERSION"
Write-Host "==============================="
Write-Host ""

# BUILD
Write-Host "Building Docker image..."
docker build --no-cache -t ${REGISTRY}/${APP}:${VERSION} .

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed"
    exit
}

# PUSH
Write-Host "Pushing to registry..."
docker push ${REGISTRY}/${APP}:${VERSION}

if ($LASTEXITCODE -ne 0) {
    Write-Host "Push failed"
    exit
}

# UPDATE KUBERNETES
Write-Host "Updating Kubernetes deployment..."

ssh fernando@192.168.11.119 "sudo /usr/local/bin/k3s kubectl set image deployment/${APP} ${APP}=${REGISTRY}/${APP}:${VERSION}"

Write-Host ""
Write-Host "DEPLOY COMPLETED"
Write-Host "Version: $VERSION"
Write-Host ""