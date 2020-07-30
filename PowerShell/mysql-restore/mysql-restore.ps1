# **** �ڍs���̃T�[�o�[��� ****
# ���[�U�[ID
$user_name=Read-Host "�ڑ���̃��[�U�[ID���w�肵�Ă�������"
# �ڑ�����
$domain=Read-Host "�ڑ���̃h���C��orIP�A�h���X���w�肵�Ă��������B"
# �閧��(.pem)�t�@�C���p�X(C:\Users�ȉ��ɔz�u���Ȃ��ƃA�N�Z�X���̖��Ŏ��s���܂�) ex."C:\Users\WordpressKeyPair.pem"
$pemfile_path=Read-Host "�閧��(.pem)�t�@�C���̕ۑ�����w�肵�Ă��������BC:\Users\�̈ȉ��ɔz�u����Ă���K�v������܂�"
# �o�b�N�A�b�v�t�@�C����ۑ������ ��F"C:\backup\dump.sql.gz"
$backup_path=Read-Host "SQL��dump�t�@�C���̕ۑ�����w�肵�Ă��������B��FC:\backup\dump.sql.gz"
# MySQL�̃��O�C�������w�肵�Ă�������
$mysql_user=Read-Host "MySQL�̃��O�C�������w�肵�Ă�������"
# MySQL�̃p�X���[�h���w�肵�Ă�������
$mysql_pass=Read-Host "MySQL�̃p�X���[�h���w�肵�Ă�������"

# ���O�C�����̍쐬
$login_info=$user_name+"@"+$domain

# SCP�ڑ�������쐬
$dump_tar_path=$login_info+":"+"/tmp/dump.sql.gz"

# SCP�ڑ����g�p���ăf�[�^���擾
scp -i $pemfile_path $backup_path $dump_tar_path

# gz�t�@�C���̉�
ssh -i $pemfile_path $login_info "gzip -d -f /tmp/dump.sql.gz"

# ���X�g�A�R�}���h�̍쐬
"���X�g�A��..."
ssh -i $pemfile_path $login_info "mysql -u $mysql_user -p$mysql_pass -h localhost -D bitnami_wordpress < /tmp/dump.sql"

# �s�v�t�@�C���̍폜
"�s�v�t�@�C���̍폜..."
ssh -i $pemfile_path $login_info "rm -f /tmp/dump.sql;rm -f /tmp/dump.sql.gz;exit;"