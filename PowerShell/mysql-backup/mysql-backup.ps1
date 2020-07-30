# **** 移行元のサーバー情報 ****
# ユーザーID
$user_name=Read-Host "接続先のユーザーIDを指定してください"
# ドメイン情報
$domain=Read-Host "接続先のドメインを指定してください。"
# 秘密鍵(.pem)ファイルパス(C:\Users以下に配置しないとアクセス権の問題で失敗します) ex."C:\Users\WordpressKeyPair.pem"
$pemfile_path=Read-Host "秘密鍵(.pem)ファイルの保存先を指定してください。C:\Users\の以下に配置されている必要があります"
# バックアップファイルを保存する先 ex."C:\backup\dump.sql.tar.gz"
$backup_path=Read-Host "SQLのdumpファイルの保存先を指定してください。ex.C:\backup"
# MySQLのログイン名を指定してください
$mysql_user=Read-Host "MySQLのログイン名を指定してください"
# MySQLのパスワードを指定してください
$mysql_pass=Read-Host "MySQLのパスワードを指定してください"


# ログイン情報の作成
$login_info=$user_name+"@"+$domain

# dump処理を実行する
ssh -i $pemfile_path $login_info "mysqldump -u $mysql_user -p$mysql_pass -h localhost bitnami_wordpress | gzip > /tmp/dump.sql.gz"

# SCP接続先情報を作成
$dump_tar_path=$login_info+":"+"/tmp/dump.sql.gz"

# SCP接続を使用してデータを取得
scp -i $pemfile_path $dump_tar_path $backup_path

# 圧縮ディレクトリを削除
"不要になった圧縮ディレクトリを削除しています。"
ssh -i $pemfile_path $login_info "rm -f /tmp/dump.sql.gz;exit;"

