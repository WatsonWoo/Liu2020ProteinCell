[TOC]

# ��¼1�����������������ݿⰲװ

    # �������������̣��汾1.06����������2019/11/1
    # ���Ի���ΪLinux Ubuntu 18.04 / CentOS 7

    # ���ݿⰲװλ�ã�Ĭ��~/dbĿ¼(�������Ȩ��)������Ա�ɰ�װ��/db����װ�����бر���������
    db=~/db
    mkdir -p ${db} && cd ${db}
    # Conda�����װĿ¼�������Ա����Ϊ/conda2�����Լ����ؿ���Ϊ~/miniconda2��~/anaconda2
    soft=~/miniconda2


    # ���������miniconda2
    wget -c https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh
    bash Miniconda2-latest-Linux-x86_64.sh
    # ��װʱ���Э��ɴ�yes��Ĭ��Ŀ¼Ϊ~/miniconda2��Ĭ�ϲ�����condaֱ�ӻس�
    conda -V # �鿴�汾�� 4.6.14
    python --version # 2.7.16
    # ��װ˵�������[Nature Method��Bioconda������������װ�ķ���](https://mp.weixin.qq.com/s/SzJswztVB9rHVh3Ak7jpfA)
    # �������Ƶ���������ҵ�����ѧ���
    conda config --add channels bioconda
    conda config --add channels conda-forge
    # condaĬ�������ļ�Ϊ ~/.condarc ���粻����ʹ�� conda config --show-sources �鿴�����ļ�λ��
    cat ~/.condarc

    # ���������Anaconda(��ѡ)
    # wget -c https://repo.anaconda.com/archive/Anaconda2-2019.03-Linux-x86_64.sh
    # bash Anaconda2-2019.03-Linux-x86_64.sh


    # ��condaΪ���������������ʵ������޸�Ŀ¼λ��
    export PATH="${soft}/bin:$PATH"
    
    # ��ѡ�������⻷������ֹ��Ⱦ��������
    conda create -n metagenome_env python=2.7 # 22.2MB
    # �°汾ʱ�滻sourceΪconda
    source activate metagenome_env


    # ���м���
    sudo apt install parallel
    parallel --version
    
    
## 1.1 �ʿ����

    # �����������fastqc
    conda install fastqc # 180 MB
    fastqc -v # FastQC v0.11.8
    
    # ����Ʒ�����������multiqc
    conda install multiqc # 111 MB
    multiqc --version # multiqc, version 1.7
    
    # ������������kneaddata
    # conda install kneaddata # kneaddata ���°� v0.7.2��ȥ���������ݼ�����˫�����ݲ���Ӧ
    # ָ����װ0.6.1
    conda install kneaddata=0.6.1 # 175 MB
    kneaddata --version # 0.6.1
    trimmomatic -version # 0.39
    bowtie2 --version # 2.3.5

    # �鿴�������ݿ�
    kneaddata_database
    # �������ࡢС������顢����ת¼��ͺ�����RNA
    # human_genome : bmtagger = http://huttenhower.sph.harvard.edu/kneadData_databases/Homo_sapiens_BMTagger_v0.1.tar.gz
    # human_genome : bowtie2 = http://huttenhower.sph.harvard.edu/kneadData_databases/Homo_sapiens_Bowtie2_v0.1.tar.gz
    # mouse_C57BL : bowtie2 = http://huttenhower.sph.harvard.edu/kneadData_databases/mouse_C57BL_6NJ_Bowtie2_v0.1.tar.gz
    # human_transcriptome : bowtie2 = http://huttenhower.sph.harvard.edu/kneadData_databases/Homo_sapiens_hg38_transcriptome_Bowtie2_v0.1.tar.gz
    # ribosomal_RNA : bowtie2 = http://huttenhower.sph.harvard.edu/kneadData_databases/SILVA_128_LSUParc_SSUParc_ribosomal_RNA_v0.1.tar.gz
    
    # �������������bowtie2����3.4 GB��ָ������Ŀ¼����ȻҲ��ѡbmtagger����
    cd ${db}
    mkdir -p ${db}/kneaddata/human_genome
    kneaddata_database --download human_genome bowtie2 ${db}/kneaddata/human_genome
    # # ������С�����������С���������о�ȥ���� 2.8 GB
    # mkdir -p ${db}/kneaddata/mouse_genome
    # kneaddata_database --download mouse_C57BL bowtie2 ${db}/kneaddata/mouse_genome
    # # ����ת¼������������غ�ת¼��ȥ���� 211 MB
    # mkdir -p ${db}/kneaddata/human_transcriptome
    # kneaddata_database --download human_transcriptome bowtie2 ${db}/kneaddata/human_transcriptome
    # # SILVA���ں�ת¼���о�ȥ�������� 3.6 GB
    # mkdir -p ${db}/kneaddata/ribosomal_RNA
    # kneaddata_database --download ribosomal_RNA bowtie2 ${db}/kneaddata/ribosomal_RNA

    # (��ѡ) ���ݿ�����������ѡ�Ϸ�����ֱ�����ء��ٶ�������(���ںź�̨�ظ������ݿ�) �� ���ڱ�������
    # mkdir -p ${db}/kneaddata/human_genome && cd ${db}/kneaddata/human_genome
    # wget -c http://210.75.224.110/share/meta/Homo_sapiens_Bowtie2_v0.1.tar.gz
    # tar -xvzf Homo_sapiens_Bowtie2_v0.1.tar.gz


## 1.2 �вη�������MetaPhlAn2��HUMAnN2

    # ��װMetaPhlAn2��HUMAnN2������������ϵ
    conda install humann2 # 141M
    humann2 --version # humann2 v0.11.2
    metaphlan2.py -v # MetaPhlAn version 2.7.5 (6 February 2018)
    diamond help #  v0.8.22.84
    
    # ���������Ƿ����
    humann2_test
    
    # �������ݿ�
    humann2_databases # ��ʾ�������ݿ�
    # utility_mapping : full = http://huttenhower.sph.harvard.edu/humann2_data/full_mapping_1_1.tar.gz
    # chocophlan : full = http://huttenhower.sph.harvard.edu/humann2_data/chocophlan/full_chocophlan_plus_viral.v0.1.1.tar.gz
    # uniref : uniref90_diamond = http://huttenhower.sph.harvard.edu/humann2_data/uniprot/uniref_annotated/uniref90_annotated_1_1.tar.gz
    # uniref : uniref50_diamond = http://huttenhower.sph.harvard.edu/humann2_data/uniprot/uniref_annotated/uniref50_annotated_1_1.tar.gz
    cd ${db}
    mkdir -p ${db}/humann2 # ��������Ŀ¼
    # ΢���ﷺ������ 5.37 GB
    humann2_databases --download chocophlan full ${db}/humann2
    # ���ܻ���diamond���� 10.3 GB
    humann2_databases --download uniref uniref90_diamond ${db}/humann2

    # ��ѡ�����ݿ�����������ѡ�Ϸ�����ֱ�����ء��ٶ�������(���ںź�̨�ظ������ݿ�) �� ���ڱ�������
    mkdir -p ${db}/humann2/chocophlan && cd ${db}/humann2/chocophlan
    wget -c http://210.75.224.110/share/meta/full_chocophlan_plus_viral.v0.1.1.tar.gz
    tar xvzf full_chocophlan_plus_viral.v0.1.1.tar.gz
    # uniref90��50��ѡ��1���Ƽ�uniref90��ȫ 5.9 GB
    cd ${db}/humann2
    wget -c http://210.75.224.110/share/meta/uniref90_annotated_1_1.tar.gz
    tar xvzf uniref90_annotated_1_1.tar.gz
    # ������С��32G�ڴ�ѡuniref50����ʡ�ڴ���� 2.5 GB
    #wget -c http://210.75.224.110/share/meta/uniref50_annotated_1_1.tar.gz
    #tar xvzf uniref50_annotated_1_1.tar.gz
    # ��Ҫͬһ�ļ����������ļ������ȱ�90���ٱ�50���ֻ���
    
    # ��ѡ��Metaphlan2���ݿ�û�ɹ����ֶ�����
    # ���ز���������
    mkdir -p ${db}/metaphlan2 && cd ${db}/metaphlan2
    wget -c http://210.75.224.110/share/meta/metaphlan2/mpa_v20_m200.tar
    tar xvf mpa_v20_m200.tar
    bzip2 -d mpa_v20_m200.fna.bz2
    bowtie2-build mpa_v20_m200.fna mpa_v20_m200
    # ���ӵ������װĿ¼
    db=~/db
    soft=~/miniconda2
    mkdir -p ${soft}/bin/db_v20
    ln -s ${db}/metaphlan2/* ${soft}/bin/db_v20/
    mkdir -p ${soft}/bin/databases
    ln -s ${db}/metaphlan2/* ${soft}/bin/databases/

    # �������ݿ�λ��
    # ��ʾ����
    humann2_config --print
    # ���޸��߳������Ƽ�3-8������ʵ���������
    humann2_config --update run_modes threads 3
    humann2_config --update database_folders nucleotide ${db}/humann2/chocophlan
    humann2_config --update database_folders protein ${db}/humann2
    # metaphlan2���ݿ�Ĭ��λ�ڳ�������Ŀ¼��db_v20��databases�¸�һ��
    humann2_config --print


### 1.2.1 �����������GraPhlAn

    # GraPhlAn���ĳ����
    conda install graphlan # 22 KB
    graphlan.py --version # GraPhlAn version 1.1.3 (5 June 2018)
    # GraPhlAn�����ļ�����������ת��LEfSe��Metaphlan2�����ʽΪGraPhlAn���ڻ�ͼ
    conda install export2graphlan # 38 KB
    export2graphlan.py -h # ver. 0.20 of 29th May 2017
    
### 1.2.2 ���ֲ���ȽϺͻ���

    conda install lefse # 57.5 MB, 1.0.8.post1

### 1.2.3 ����ע��Kraken2

    # ����ע��
    # ����LCA�㷨������ע��kraken2  https://ccb.jhu.edu/software/kraken/
    conda install kraken2 # 2.8 MB
    kraken2 --version # 2.0.8-beta 2019

    # �������ݿ�
    cd ${db}
    # --standard��׼ģʽ��ֻ����5�����ݿ⣺�ž�archaea��ϸ��bacteria������human������UniVec_Core������viral
    # �˲��������� > 50GB��ռ��100 GB�ռ䣬����ʱ�������پ���������ʱ��4Сʱ33�֣����߳����35min���
    kraken2-build --standard --threads 24 --db ${db}/kraken2

    # ���Ի��������ݿ�(��ѡ����� https://github.com/DerrickWood/kraken2/blob/master/docs/MANUAL.markdown)


## 1.3 ������ƴ�ӡ�ע�ͺͶ���

    # megahit ������װ
    conda install megahit # 6.4 MB
    megahit -v # v1.1.3
    
    # metaSPAdesƴ�ӣ�ֻ��spadesϵ���е�һ�����ƽű�
    conda install spades # 13.7 MB
    metaspades.py -v # SPAdes v3.13.1 [metaSPAdes mode]
    
    # QUEST ��װ����
    conda install quast # 87.2 MB
    metaquast.py -v # QUAST v5.0.2 (MetaQUAST mode)
    
    # prokka ϸ��������ע��
    conda install prokka # 352.8 MB
    prokka -v # 1.13.3
    
    # cd-hit ���������
    conda install cd-hit # 790 KB
    cd-hit -v # 4.8.1 (built on May 14 2019)
    
    # emboss transeq����
    conda install emboss # 94.5 MB
    embossversion # 6.6.0.0
    
    # ��������salmon
    conda install salmon # 15.1 MB
    salmon -v # 0.13.1


## 1.4 ������ע��

    ### COG/eggNOG http://eggnogdb.embl.de
    # ��װeggnog�ȶԹ���
    conda install eggnog-mapper # 0.13.1
    emapper.py --version # 1.0.3
    
    # ���س������ݿ⣬ע����������λ��
    mkdir -p ${db}/eggnog && cd ${db}/eggnog
    download_eggnog_data.py --data_dir ./ -y -f euk bact arch viruses
    # ����ڴ湻�󣬸���eggNOG���ڴ���ٱȶ�
    # cp eggnog.db /dev/shm
    # �ֹ�����COG����ע��
    wget -c wget http://210.75.224.110/share/COG.anno
    # �ֹ�����KOע��
    wget -c wget http://210.75.224.110/share/KO.anno
    
    # eggNOG mapper v2 https://github.com/eggnogdb/eggnog-mapper/wiki/eggNOG-mapper-v2#Installation
    git clone https://github.com/jhcepas/eggnog-mapper.git
    python eggnog-mapper/emapper.py --version # 1.0.3��ͬ��

    
    
    ### ̼ˮ���������ݿ�dbCAN2 http://cys.bios.niu.edu/dbCAN2/
    mkdir -p ${db}/dbCAN2 && cd ${db}/dbCAN2
    # ��������ݿ��޷����ʣ����ù��ڱ�������
    # wget -c http://cys.bios.niu.edu/dbCAN2/download/CAZyDB.07312018.fa
    # wget -c http://cys.bios.niu.edu/dbCAN2/download/CAZyDB.07312018.fam-activities.txt
    wget -c http://210.75.224.110/share/meta/dbcan2/CAZyDB.07312018.fa # 497 MB
    wget -c http://210.75.224.110/share/meta/dbcan2/CAZyDB.07312018.fam-activities.txt # 58 KB
    time diamond makedb --in CAZyDB.07312018.fa --db CAZyDB.07312018 # 28s
    # ��ȡfam��Ӧע��
    grep -v '#' CAZyDB.07312018.fam-activities.txt|sed 's/  //'| \
      sed '1 i ID\tDescription' > fam_description.txt
    
    ### �����ؿ��Ի���Resfam http://dantaslab.wustl.edu/resfams
    mkdir -p ${db}/resfam && cd ${db}/resfam
    # ���������ݸ�ʽ�ǳ�����, �Ƽ��������ֶ������������ע��
    wget http://210.75.224.110/share/Resfams-proteins.dmnd # 1.5 MB
    wget http://210.75.224.110/share/Resfams-proteins_class.tsv # 304 KB


## 1.5 ���乤��

    # ����ע�ͺͷ������� https://github.com/bxlab/metaWRAP
    conda create -n metawrap python=2.7 # 22.2MB
    conda activate metawrap
    conda config --add channels ursky
    conda install -c ursky metawrap-mg # 1.14 GB, v1.2
    
    conda list # ��ʾ����б�
    conda env list # ��ʾ�����б�
    kraken -v # �鿴����汾 1.1.1
    # conda deactivate # �˳�����
    
    # ������ݿ⣬��С��300GB
    # �������ǰ�װ���ݿ⵽`~/db`Ŀ¼����֤����Ȩ�ޣ���Ҫ��֤������500GB�Ŀռ䡣������������޸�Ϊ�Լ���Ȩ���ҿռ��㹻��λ�á�
    # ����ʹ�ã��������Աͳһ��װ��ʡ�ռ�
    cd ${db}

    ## CheckM����Bin��������Ⱦ���ƺ�����ע��
    mkdir -p checkm && cd checkm
    # �����ļ�275 MB����ѹ��1.4 GB
    wget -c https://data.ace.uq.edu.au/public/CheckM_databases/checkm_data_2015_01_16.tar.gz
    # ���ڱ�������
    # wget -c http://210.75.224.110/share/meta/checkm/checkm_data_2015_01_16.tar.gz
    tar -xvf *.tar.gz
    # rm *.gz
    # �������ݿ�λ��
    checkm data setRoot
    # ����ʾ������������ص�·����ֱ�ӻس�Ĭ��Ϊ��ǰλ��
    
    ## NCBI_nt������������bin����ע��
    # 41GB�������ش�Լ12h����ѹ��99GB
    cd ${db}
    mkdir -p NCBI_nt && cd NCBI_nt
    wget -c "ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.*.tar.gz"
    # �����������ӣ���ٶ�������
    # wget -c http://210.75.224.110/share/meta/NCBI_nt/filelist.txt
    # for a in `cat filelist.txt`; do wget -c http://210.75.224.110/share/meta/NCBI_nt/$a; done
    for a in nt.*.tar.gz; do tar xzf $a; done &
    
    ## NCBI������Ϣ
    # ѹ���ļ�45M����ѹ��351M
    cd ${db}
    mkdir NCBI_tax
    cd NCBI_tax
    wget ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump.tar.gz
    tar -xvf taxdump.tar.gz
    
    ## ���������ȥ����
    cd ${db}
    mkdir -p metawrap/BMTAGGER && cd metawrap/BMTAGGER
    wget -c ftp://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/*fa.gz
    gunzip *fa.gz
    cat *fa > hg38.fa
    rm chr*.fa
    # �Ϸ�����̫����ʹ�ù��ڱ��������ֶ�����
    wget -c http://210.75.224.110/share/meta/metawrap/BMTAGGER/hg38.fa
    bmtool -d hg38.fa -o hg38.bitmask
    srprism mkindex -i hg38.fa -o hg38.srprism -M 100000
    
    ## KRAKEN����ע�����ݿ�
    # ���ؽ�������Ҫ > 300GB���Ͽռ䣬��ɺ�ռ��192GB�ռ�
    cd ${db}
    mkdir -p kraken
    kraken-build --standard --threads 24 --db kraken > log &
    kraken-build --db kraken --clean
    # �ֶ�����
    cd kraken
    wget -c http://210.75.224.110/share/meta/kraken/database.kdb
    wget -c http://210.75.224.110/share/meta/kraken/database.idx
    mkdir -p taxonomy && cd taxonomy
    wget -c http://210.75.224.110/share/meta/kraken/taxonomy/nodes.dmp
    wget -c http://210.75.224.110/share/meta/kraken/taxonomy/names.dmp
    # ������λ�ø���
    # cp -r /db/kraken/* ./
    
    ## ���ݿ�λ������
    which config-metawrap
    # �����ļ�ͨ��Ϊ~/miniconda2/envs/metawrap/bin/config-metawrap
    # ʹ��Rstudio/vim���ı��༭�����޸����ݿ��λ��
    
    # �����װ���ʱ����������Krona�������ݿ⣬���Ի����ݿ�λ�õķ���
    # ����Ŀ��Ĭ��Ŀ¼Ϊ��������ɰ������ݿ�λ��
    # rm -rf ~/miniconda2/envs/metawrap/opt/krona/taxonomy
    # mkdir -p ~/db/krona/taxonomy
    # ln -s ~/db/krona/taxonomy ~/miniconda2/envs/metawrap/opt/krona/taxonomy
    # ktUpdateTaxonomy.sh

    # QUAST����Ĭ��û�������ݿ⣬���ؿ����������������Ϣ
    # - The default QUAST package does not include:
    # * GRIDSS (needed for structural variants detection)
    # * SILVA 16S rRNA database (needed for reference genome detection in metagenomic datasets)
    # * BUSCO tools and databases (needed for searching BUSCO genes) -- works in Linux only!
    # ����QUAST�������ݿ�
    # quast-download-gridss # 38 MB��~/miniconda2/envs/metawrap/lib/python2.7/site-packages/quast_libs/gridss/gridss-1.4.1.jar
    # quast-download-silva # 177 MB
    # quast-download-busco

  
    
## 1.6 ��������������ű�
    
    # ��ע�����ͺϲ��ű������� https://github.com/YongxinLiu/Metagenome
    cd ${db}
    mkdir script && cd script
    # ���������ע�ͺϲ��Ľű�����Gene-KO-Module-Pathway�ĺϲ�
    wget http://210.75.224.110/share/meta/script/mat_gene2ko.R
    # ����Kraken2�Ľ������alpha������
    wget http://210.75.224.110/share/meta/script/kraken2alpha.R
    # ����alpha�����Ժͷ�����Ϣ��������ͼ
    wget http://210.75.224.110/share/meta/script/alpha_boxplot.R
    chmod +x *.R

    
    # Bin���ӻ�VizBin
    # sudo apt-get install libatlas3-base libopenblas-base default-jre
    # curl -L https://github.com/claczny/VizBin/blob/master/VizBin-dist.jar?raw=true > VizBin-dist.jar
    # mv VizBin-dist.jar /usr/local/bin # ��~/bin
    
    # �ȶԽ������samtools
    conda install samtools

    ### CARD(ѡѧ) https://card.mcmaster.ca/download 
    # ����1. ֱ��conda��װ
    conda install --channel bioconda rgi
    # ����������Է���2��CondaMultiError: CondaFileIOError: '/home/liuyongxin/miniconda2/pkgs/prokka-1.11-0.tar.bz2'. contains unsafe path: db/cm/READM
    # ����2. ���⻷����װ
    conda activate metawrap
    conda install --channel bioconda rgi
    rgi main -v # 4.0.3
    # rgi�̳� https://github.com/arpcard/rgi
    
  

## ��¼

