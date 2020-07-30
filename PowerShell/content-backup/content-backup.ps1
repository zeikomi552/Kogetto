# **** 移行元のサーバー情報 ****
# ユーザーID
$user_name=Read-Host "接続先のユーザーIDを指定してください"
# ドメイン情報
$domain=Read-Host "接続先のドメインを指定してください。"
# 秘密鍵(.pem)ファイルパス(C:\Users以下に配置しないとアクセス権の問題で失敗します) ex."C:\Users\WordpressKeyPair.pem"
$pemfile_path=Read-Host "秘密鍵(.pem)ファイルの保存先を指定してください。C:\Users\の以下に配置されている必要があります"
# バックアップファイルを保存する先 ex."C:\backup"
$backup_path=Read-Host "取り出したバックアップの保存先を指定してください"

# ログイン情報の作成
$login_info=$user_name+"@"+$domain

# 各ディレクトリを圧縮
ssh -i $pemfile_path $login_info "cd /opt/bitnami/apps/wordpress/htdocs/wp-content/;tar zcvf uploads.tar.gz uploads;"
ssh -i $pemfile_path $login_info "cd /opt/bitnami/apps/wordpress/htdocs/wp-content/;tar zcvf plugins.tar.gz plugins;"
ssh -i $pemfile_path $login_info "cd /opt/bitnami/apps/wordpress/htdocs/wp-content/;tar zcvf themes.tar.gz themes;"

# SCP接続先情報を作成
$uploads_tar_path=$login_info+":"+"/opt/bitnami/apps/wordpress/htdocs/wp-content\uploads.tar.gz"
$plugins_tar_path=$login_info+":"+"/opt/bitnami/apps/wordpress/htdocs/wp-content\plugins.tar.gz"
$themes_tar_path=$login_info+":"+"/opt/bitnami/apps/wordpress/htdocs/wp-content\themes.tar.gz"

# SCP接続してローカルに保存
scp -i $pemfile_path $uploads_tar_path $backup_path
scp -i $pemfile_path $plugins_tar_path $backup_path
scp -i $pemfile_path $themes_tar_path $backup_path

# 圧縮ディレクトリを削除
"不要になった圧縮ディレクトリを削除しています。"
ssh -i $pemfile_path $login_info "cd /opt/bitnami/apps/wordpress/htdocs/wp-content;rm -f /uploads.tar.gz;rm -f /plugins.tar.gz;rm -f themes.tar.gz;exit;"
