# ecs-with-blue-green

## 事前に必要なもの

- Terraformを実行可能なIAMユーザー(十分な権限を持っている必要があります)
- Stateを格納するS3バケット
- ECRリポジトリ
    - 最初のイメージはpush済である必要があるかもしれません
- デプロイ対象となるアプリケーションのGitHub リポジトリ
    - ソースコード中の `docker/web/Dockerfile` にDockerfileがあることを想定しています。
    - 初回のterraform applyはGitHubの承認待ちで失敗するかもしれません

## 実行方法

- main.tf.dist を main.tfにリネーム
    - bucket名やプロフィール名を適宜修正
- terraform.tfvars.dist を terraform.tfvarsにリネーム
    - 各種変数に値を記入
- `terraform init`
- `terraform plan`
- `terraform apply`
