# **** �ڍs���̃T�[�o�[��� ****
# ���[�U�[ID
$user_name=Read-Host "�ڑ���̃��[�U�[ID���w�肵�Ă�������"
# �h���C�����
$domain=Read-Host "�ڑ���̃h���C�����w�肵�Ă��������B"
# �閧��(.pem)�t�@�C���p�X(C:\Users�ȉ��ɔz�u���Ȃ��ƃA�N�Z�X���̖��Ŏ��s���܂�) ex."C:\Users\WordpressKeyPair.pem"
$pemfile_path=Read-Host "�閧��(.pem)�t�@�C���̕ۑ�����w�肵�Ă��������BC:\Users\�̈ȉ��ɔz�u����Ă���K�v������܂�"
# �o�b�N�A�b�v�t�@�C����ۑ������ ex."C:\backup\dump.sql.tar.gz"
$backup_path=Read-Host "SQL��dump�t�@�C���̕ۑ�����w�肵�Ă��������Bex.C:\backup"
# MySQL�̃��O�C�������w�肵�Ă�������
$mysql_user=Read-Host "MySQL�̃��O�C�������w�肵�Ă�������"
# MySQL�̃p�X���[�h���w�肵�Ă�������
$mysql_pass=Read-Host "MySQL�̃p�X���[�h���w�肵�Ă�������"


# ���O�C�����̍쐬
$login_info=$user_name+"@"+$domain

# dump���������s����
ssh -i $pemfile_path $login_info "mysqldump -u $mysql_user -p$mysql_pass -h localhost bitnami_wordpress | gzip > /tmp/dump.sql.gz"

# SCP�ڑ�������쐬
$dump_tar_path=$login_info+":"+"/tmp/dump.sql.gz"

# SCP�ڑ����g�p���ăf�[�^���擾
scp -i $pemfile_path $dump_tar_path $backup_path

# ���k�f�B���N�g�����폜
"�s�v�ɂȂ������k�f�B���N�g�����폜���Ă��܂��B"
ssh -i $pemfile_path $login_info "rm -f /tmp/dump.sql.gz;exit;"

