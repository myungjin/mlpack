#!/usr/bin/env bash

PUSH=false
while [[ $# -gt 0 ]]; do
    case $1 in
	-p|--push)
	    PUSH=true
	    shift # past argument
	    ;;
	-*|--*|*)
	    echo "Unknown option $1"
	    exit 1
	    ;;
    esac
done

function main {
    REGISTRY=myungjinlee
    CUDA_VERSION=cuda11.3

    PROJECT=mlpack

    DOCKER_BUILDKIT=1
    
    RESOURCES=(cpu gpu)
    FRAMEWORKS=(allinone pytorch tensorflow)
    for resource in ${RESOURCES[@]}; do
	for framework in ${FRAMEWORKS[@]}; do
	    DOCKERFILE=Dockerfile.${resource}
	    URI=${PROJECT}:${framework}-${resource}
	    if [[ "${resource}" == "gpu" ]]; then
		URI=${PROJECT}:${framework}-${CUDA_VERSION}
	    else
		URI=${PROJECT}:${framework}-${resource}
	    fi

	    docker build -f ${DOCKERFILE} --tag ${URI} --build-arg FRAMEWORK=${framework} .
	    docker image tag ${URI} ${REGISTRY}/${URI}
	done
    done

    if [[ "${PUSH}" == "false" ]]; then
	exit 0
    fi
    
    for resource in ${RESOURCES[@]}; do
	for framework in ${FRAMEWORKS[@]}; do
	    DOCKERFILE=Dockerfile.${resource}
	    URI=${PROJECT}:${framework}-${resource}
	    if [[ "${resource}" == "gpu" ]]; then
		URI=${PROJECT}:${framework}-${CUDA_VERSION}
	    else
		URI=${PROJECT}:${framework}-${resource}
	    fi

	    docker image push ${REGISTRY}/${URI}
	done
    done
}

main
