# **** 移行元のサーバー情報 ****
# ユーザーID
$user_name=Read-Host "接続先のユーザーIDを指定してください"
# ドメイン情報
$domain=Read-Host "接続先のドメインorIPアドレスを指定してください。"
# 秘密鍵(.pem)ファイルパス(C:\Users以下に配置しないとアクセス権の問題で失敗します) ex."C:\Users\WordpressKeyPair.pem"
$pemfile_path=Read-Host "秘密鍵(.pem)ファイルの保存先を指定してください。C:\Users\の以下に配置されている必要があります"
# バックアップファイルを保存する先 ex."C:\backup"
$backup_path=Read-Host "バックアップの保存先を指定してください  ex.C:\backup"

# ログイン情報の作成
$login_info=$user_name+"@"+$domain

$uploads_tar_path=$backup_path+"/uploads.tar.gz"
$plugins_tar_path=$backup_path+"/plugins.tar.gz"
$themes_tar_path=$backup_path+"/themes.tar.gz"
$upp_dir=$login_info+":"+"/opt/bitnami/apps/wordpress/htdocs/wp-content/"


# SCP接続してバックアップファイルをアップロード
scp -i $pemfile_path $uploads_tar_path $upp_dir
scp -i $pemfile_path $plugins_tar_path $upp_dir
scp -i $pemfile_path $themes_tar_path $upp_dir

# オリジナルのディレクトリをリネーム
"リネームします"
ssh -i $pemfile_path $login_info "cd /opt/bitnami/apps/wordpress/htdocs/wp-content/;mv uploads/ _uploads/;mv plugins/ _plugins/;mv themes/ _themes/;"
"解凍してtar.gzを削除"
ssh -i $pemfile_path $login_info "cd /opt/bitnami/apps/wordpress/htdocs/wp-content/;tar -zxvf uploads.tar.gz;tar -zxvf plugins.tar.gz;tar -zxvf themes.tar.gz;rm -f uploads.tar.gz;rm -f plugins.tar.gz;rm -f themes.tar.gz;"
"所有者の変更"
ssh -i $pemfile_path $login_info "cd /opt/bitnami/apps/wordpress/htdocs/wp-content/;sudo chown bitnami:daemon -R uploads;sudo chown bitnami:daemon -R plugins;sudo chown bitnami:daemon -R themes;"
"権限の変更"
ssh -i $pemfile_path $login_info "cd /opt/bitnami/apps/wordpress/htdocs/wp-content/uploads;sudo chown daemon:daemon -R *;sudo chmod 664 -R *;sudo find . -type d -exec chmod 775 {} +;"
ssh -i $pemfile_path $login_info "cd /opt/bitnami/apps/wordpress/htdocs/wp-content/plugins;sudo chown daemon:daemon -R all-in-one-seo-pack;sudo chmod 664 -R *;sudo find . -type d -exec chmod 775 {} +;"
ssh -i $pemfile_path $login_info "cd /opt/bitnami/apps/wordpress/htdocs/wp-content/themes;sudo chmod 664 -R *;sudo find . -type d -exec chmod 775 {} +;"