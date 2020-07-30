# **** �ڍs���̃T�[�o�[��� ****
# ���[�U�[ID
$user_name=Read-Host "�ڑ���̃��[�U�[ID���w�肵�Ă�������"
# �h���C�����
$domain=Read-Host "�ڑ���̃h���C��orIP�A�h���X���w�肵�Ă��������B"
# �閧��(.pem)�t�@�C���p�X(C:\Users�ȉ��ɔz�u���Ȃ��ƃA�N�Z�X���̖��Ŏ��s���܂�) ex."C:\Users\WordpressKeyPair.pem"
$pemfile_path=Read-Host "�閧��(.pem)�t�@�C���̕ۑ�����w�肵�Ă��������BC:\Users\�̈ȉ��ɔz�u����Ă���K�v������܂�"
# �o�b�N�A�b�v�t�@�C����ۑ������ ex."C:\backup"
$backup_path=Read-Host "�o�b�N�A�b�v�̕ۑ�����w�肵�Ă�������  ex.C:\backup"

# ���O�C�����̍쐬
$login_info=$user_name+"@"+$domain

$uploads_tar_path=$backup_path+"/uploads.tar.gz"
$plugins_tar_path=$backup_path+"/plugins.tar.gz"
$themes_tar_path=$backup_path+"/themes.tar.gz"
$upp_dir=$login_info+":"+"/opt/bitnami/apps/wordpress/htdocs/wp-content/"


# SCP�ڑ����ăo�b�N�A�b�v�t�@�C�����A�b�v���[�h
scp -i $pemfile_path $uploads_tar_path $upp_dir
scp -i $pemfile_path $plugins_tar_path $upp_dir
scp -i $pemfile_path $themes_tar_path $upp_dir

# �I���W�i���̃f�B���N�g�������l�[��
"���l�[�����܂�"
ssh -i $pemfile_path $login_info "cd /opt/bitnami/apps/wordpress/htdocs/wp-content/;mv uploads/ _uploads/;mv plugins/ _plugins/;mv themes/ _themes/;"
"�𓀂���tar.gz���폜"
ssh -i $pemfile_path $login_info "cd /opt/bitnami/apps/wordpress/htdocs/wp-content/;tar -zxvf uploads.tar.gz;tar -zxvf plugins.tar.gz;tar -zxvf themes.tar.gz;rm -f uploads.tar.gz;rm -f plugins.tar.gz;rm -f themes.tar.gz;"
"���L�҂̕ύX"
ssh -i $pemfile_path $login_info "cd /opt/bitnami/apps/wordpress/htdocs/wp-content/;sudo chown bitnami:daemon -R uploads;sudo chown bitnami:daemon -R plugins;sudo chown bitnami:daemon -R themes;"
"�����̕ύX"
ssh -i $pemfile_path $login_info "cd /opt/bitnami/apps/wordpress/htdocs/wp-content/uploads;sudo chown daemon:daemon -R *;sudo chmod 664 -R *;sudo find . -type d -exec chmod 775 {} +;"
ssh -i $pemfile_path $login_info "cd /opt/bitnami/apps/wordpress/htdocs/wp-content/plugins;sudo chown daemon:daemon -R all-in-one-seo-pack;sudo chmod 664 -R *;sudo find . -type d -exec chmod 775 {} +;"
ssh -i $pemfile_path $login_info "cd /opt/bitnami/apps/wordpress/htdocs/wp-content/themes;sudo chmod 664 -R *;sudo find . -type d -exec chmod 775 {} +;"