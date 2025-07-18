# gj-korcharm-3p-terraform

## 개요
이 프로젝트는 AWS 인프라를 Terraform으로 관리하며, React 프론트엔드와 Spring Boot 백엔드를 포함한 구조입니다. 각 서비스는 별도의 ALB와 EC2 인스턴스(혹은 Launch Template)로 배포됩니다.

## 구성 파일
- `main.tf`: Terraform 백엔드(S3) 설정
- `vpc.tf`: VPC, 서브넷, IGW, 라우팅 테이블 등 네트워크 리소스 정의
- `security_groups.tf`: React, Spring Boot, DocumentDB용 보안 그룹 정의
- `react_alb_asg.tf`: React 서비스용 ALB, Target Group, EC2 인스턴스 및 Launch Template 정의
- `spring_alb_asg.tf`: Spring Boot 서비스용 ALB, Target Group, EC2 인스턴스 및 Launch Template 정의
- `variables.tf`: 변수 정의 (GitHub 인증 등)
- `outputs.tf`: 주요 리소스의 출력값 정의 (ALB DNS, 서브넷 ID, 보안 그룹 ID 등)

## 배포 방법

### 1. 변수 및 AWS 인증 정보 준비
- GitHub Actions에서 다음 시크릿을 등록해야 합니다:
  - `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`
  - `GH_USERNAME`, `GH_TOKEN`

### 2. GitHub Actions로 배포/삭제
- 수동 실행(workflow_dispatch)으로 배포/삭제 가능
- `.github/workflows/deploy.yml`: `Terraform Apply` 실행
- `.github/workflows/destroy.yml`: `Terraform Destroy` 실행

### 3. 수동 배포
```sh
terraform init
terraform apply \
  -var="gh_username=..." \
  -var="gh_token=..." \
```

## 주요 리소스 설명

- **VPC 및 서브넷**: React/Spring 각각 2개씩 퍼블릭 서브넷 구성
- **보안 그룹**: 서비스별로 HTTP 등 인바운드/아웃바운드 규칙 설정
- **ALB/Target Group**: React(80), Spring Boot(8080)용 ALB 및 Target Group
- **EC2 인스턴스**: 각 서비스별로 2개 인스턴스(2a, 2c AZ) 배포, Docker로 컨테이너 실행
- **Launch Template**: EC2 자동화 배포를 위한 템플릿

## 출력값(outputs)
- React/Spring ALB DNS
- 각 퍼블릭 서브넷 ID
- 각 서비스 보안 그룹 ID
- VPC ID

---

> 자세한 리소스 구조 및 변수 설명은 각 `.tf` 파일을 참고하세요.