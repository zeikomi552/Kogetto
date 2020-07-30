# **** �ڍs���̃T�[�o�[��� ****
# ���[�U�[ID
$user_name=Read-Host "�ڑ���̃��[�U�[ID���w�肵�Ă�������"
# �h���C�����
$domain=Read-Host "�ڑ���̃h���C�����w�肵�Ă��������B"
# �閧��(.pem)�t�@�C���p�X(C:\Users�ȉ��ɔz�u���Ȃ��ƃA�N�Z�X���̖��Ŏ��s���܂�) ex."C:\Users\WordpressKeyPair.pem"
$pemfile_path=Read-Host "�閧��(.pem)�t�@�C���̕ۑ�����w�肵�Ă��������BC:\Users\�̈ȉ��ɔz�u����Ă���K�v������܂�"
# �o�b�N�A�b�v�t�@�C����ۑ������ ex."C:\backup"
$backup_path=Read-Host "���o�����o�b�N�A�b�v�̕ۑ�����w�肵�Ă�������"

# ���O�C�����̍쐬
$login_info=$user_name+"@"+$domain

# �e�f�B���N�g�������k
ssh -i $pemfile_path $login_info "cd /opt/bitnami/apps/wordpress/htdocs/wp-content/;tar zcvf uploads.tar.gz uploads;"
ssh -i $pemfile_path $login_info "cd /opt/bitnami/apps/wordpress/htdocs/wp-content/;tar zcvf plugins.tar.gz plugins;"
ssh -i $pemfile_path $login_info "cd /opt/bitnami/apps/wordpress/htdocs/wp-content/;tar zcvf themes.tar.gz themes;"

# SCP�ڑ�������쐬
$uploads_tar_path=$login_info+":"+"/opt/bitnami/apps/wordpress/htdocs/wp-content\uploads.tar.gz"
$plugins_tar_path=$login_info+":"+"/opt/bitnami/apps/wordpress/htdocs/wp-content\plugins.tar.gz"
$themes_tar_path=$login_info+":"+"/opt/bitnami/apps/wordpress/htdocs/wp-content\themes.tar.gz"

# SCP�ڑ����ă��[�J���ɕۑ�
scp -i $pemfile_path $uploads_tar_path $backup_path
scp -i $pemfile_path $plugins_tar_path $backup_path
scp -i $pemfile_path $themes_tar_path $backup_path

# ���k�f�B���N�g�����폜
"�s�v�ɂȂ������k�f�B���N�g�����폜���Ă��܂��B"
ssh -i $pemfile_path $login_info "cd /opt/bitnami/apps/wordpress/htdocs/wp-content;rm -f /uploads.tar.gz;rm -f /plugins.tar.gz;rm -f themes.tar.gz;exit;"
