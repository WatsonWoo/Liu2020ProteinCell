[TOC]

#!/bin/bash
    # ���� Authors: Yong-Xin Liu, Tong Chen, Xin Zhou, Tao Wen, Liang Chen, ...
    # �汾 Version: v1.70
    # ���� Update: 2020-01-03

    # �������/���ݿ�(database,db)�͹���Ŀ¼(work directory,wd)������wd
    # **ÿ�δ�Rstudio������������3��**
    db=/c/public
    wd=/c/amplicon
    cd ${wd}


# 22�������ӷ������� 16S Amplicon pipeline

    # ϵͳҪ�� System requirement: Windows 10 / Mac OS 10.12+ / Ubuntu 18.04
    # ������������� Sofware and database dependencies: ����publicĿ¼��C��
    # gitforwidnows 2.23.0 http://gitforwindows.org/(Windows only)
    # R 3.6.1 https://www.r-project.org/
    # Rstudio 1.2.5019 https://www.rstudio.com/products/rstudio/download/#download
    # vsearch v2.14.1 https://github.com/torognes/vsearch/releases
    # usearch v10.0.240 https://www.drive5.com/usearch/download.html

    # ����ǰ׼��
    # 1. ��amplicon��publicĿ¼���Ƶ�C��(C:/) �� Mac/Linux��������Ŀ¼(~/)
    # 2. ѧԱ��U��`01PPT/11�����������װ�Ͳ����ֲ�.pdf`�μ�˵����װ���
    # 3. �������ٰ�����������seq/*.fq.gz������Ԫ����result/metadata.tsv�����̽ű�pipeline.sh
    # 3. Rstudio��pipeline.sh�ļ�������Ĭ��Ŀ¼ΪC:/amplicon �� Terminal�л�������Ŀ¼
    # Linux�������û�Chrome����'IP��ַ:8787'��½Rstudio��ҳ�棬ѡ�д��밴Ctrl+Shift+C�л�ע��


## 1. �˽⹤��Ŀ¼����ʼ�ļ�

    #1. ԭʼ�������ݱ�����seqĿ¼��ͨ����`.fq.gz`��β��ÿ����Ʒһ���ļ�
    mkdir -p seq
    ls -lsh seq
    #2. ������Ϣ����ʵ����� metadata.tsv�����������ս��resultĿ¼
    mkdir -p result
    #3. ��������pipeline.sh��ÿ����Ŀ����һ�ݣ��ٽ��и��Ի��޸�
    #4. ������ʱ�ļ��洢Ŀ¼������������ɾ��
    mkdir -p temp

### 1.1. metadata.tsv ʵ������ļ�

    #cat�鿴ǰ3�У�-A��ʾ����
    cat -A result/metadata.tsv | head -n3
    #windows�û������β��^M������sed����ȥ������cat -A�����
    # sed -i 's/\r/\n/' result/metadata.tsv
    # cat -A result/metadata.tsv | head -n3

### 1.2. seq/*.fq.gz ԭʼ��������

    # ��˾���صĲ�������ͨ��Ϊһ����Ʒһ��fq/fastq.gz��ʽѹ���ļ�
    # �ļ�������Ʒ����ض�Ӧ����һ��ʱ�������ֹ�����������������������μ�`��������`6��������������Ƽ� https://github.com/shenwei356/brename
    # zless��ҳ�鿴ѹ���ļ��������·����������ո�ҳ��q�˳���ע�����뷨����Ӣ��״̬
    # zless seq/KO1_1.fq.gz
    # �������������.gz��ѹ���ļ���ʹ��gunzip��ѹ��21s
    time gunzip seq/*.gz
    # less��ҳ�鿴���ո�ҳ��q�˳���head�鿴ǰ10�У�-nָ����
    ls seq/
    head -n4 seq/KO1_1.fq
    # cut -c 1-60 seq/KO1_1.fq | head -n4

### 1.3. pipeline.sh �����������ݿ�

    # ���ݿ��һ��ʹ�ñ����ѹ����ѹ���������˶�

    # usearchʹ��16S���ݿ⣺ RDP, SILVA and UNITE�������ļ�λ�� ${db}/usearch/
    # usearch���ݿ�database����ҳ: http://www.drive5.com/sintax
    # ��ѹrdp��������ע�ͺ�silva����ȥǶ���壬*���������ַ���ѡ����fa.gz��β���ļ�
    time gunzip ${db}/usearch/*.fa.gz # 51s
    # �鿴ע�����ݿ�ĸ�ʽ
    head -n2 ${db}/usearch/rdp_16s_v16_sp.fa

    # QIIME greengene 13_8�в����ݿ����ڹ���ע��: ftp://greengenes.microbio.me/greengenes_release/gg_13_5/gg_13_8_otus.tar.gz
    gunzip ${db}/gg/*.fasta.gz


## 2. �ϲ�˫�����в�����Ʒ������ Merge paired reads and label samples

    # ��WT1����Ʒ�ϲ�Ϊ����ֻΪ���ԣ��Ժ�·��
    # time ${db}/win/vsearch --fastq_mergepairs seq/WT1_1.fq \
    #   --reverse seq/WT1_2.fq \
    #   --fastqout temp/WT1.merged.fq \
    #   --relabel WT1.

    #����ʵ������������ϲ�
    #tail -n+2ȥ��ͷ��cut -f 1ȡ��һ�У�����������б�18��5������������ϲ�2m
    #��Ϊϵͳ����Ctrl+CΪLinux����ֹ�����ֹ��ʱ�������쳣�жϣ���β���&ת��̨

    # tail -n+2 result/metadata.tsv
    # tail -n+2 result/metadata.tsv | cut -f 1
    # for i in `tail -n+2 result/metadata.tsv | cut -f 1`;do echo ${i}; done

    time for i in `tail -n+2 result/metadata.tsv | cut -f 1`;do
      ${db}/win/vsearch --fastq_mergepairs seq/${i}_1.fq --reverse seq/${i}_2.fq \
      --fastqout temp/${i}.merged.fq --relabel ${i}.
    done &
    # & ����ת��̨����ֹ�����жϣ�Terminal���Ͻ���С��㣬������������

    # �����ϲ�����ֱ�Ӹ���������������̣��滻����${db}/win/vsearch --fastq_mergepairs����Ϊ
    # ${db}/win/usearch -fastx_relabel seq/${i}.fq -fastqout temp/${i}.merged.fq -prefix ${i}.
    # ��һ�ַ����ο����������⡱������2. ����˫���Ѿ��ϲ�������������������/�����������

    #�ϲ�������Ʒ��ͬһ�ļ�
    cat temp/*.merged.fq > temp/all.fq
    #�鿴�ļ���С634M�������ͬ�汾������в���
    ls -lsh temp/all.fq
    #�鿴������.֮ǰ�Ƿ�Ϊ������������������������.
    head -n 6 temp/all.fq|cut -c1-60


## 3. �г��������ʿ� Cut primers and quality filter

    # Cut barcode 10bp + V5 19bp in left and V7 18bp in right
    # ���10bp Barcode+19bp��������Ϊ29���Ҷ�Ϊ18bp����������18
    # ������ʵ����ƺ����ﳤ�ȣ������Ѿ�ȥ������0��76��������37s
    time ${db}/win/vsearch --fastx_filter temp/all.fq \
      --fastq_stripleft 29 --fastq_stripright 18 \
      --fastq_maxee_rate 0.01 \
      --fastaout temp/filtered.fa

    # �鿴�ļ�ǰ2�У��˽�fa�ļ���ʽ
    head -n 2 temp/filtered.fa


## 4. ȥ������ѡOTU/ASV Dereplicate and cluster/denoise

### 4.1 ����ȥ���� Dereplication

    # �����miniuniqusize��СΪ10��1/1M��ȥ���ͷ�����������Ӽ����ٶ�
    # -sizeout������, --relabel���������ǰ׺�������ļ�ͷ������, 10s
    time ${db}/win/vsearch --derep_fulllength temp/filtered.fa \
      --output temp/uniques.fa --relabel Uni --minuniquesize 10 --sizeout
    #�߷�ȷ��������зǳ�С(<2Mb),���ƺ���size��Ƶ��
    ls -lsh temp/uniques.fa
    head -n 2 temp/uniques.fa

### 4.2 ����OTU/ȥ��ASV Cluster OTUs / denoise ASV

    #�����ַ������Ƽ�unoise3ȥ���õ��������ASV����ͳ��97%����OTU (��ˮƽ����)����ѡ
    #usearch����������ѡ�������Դ�de novoȥǶ����

    #����1. 97%����OTU���ʺϴ�����/ASV���ɲ�����/reviewerҪ��
    #�����ʱ6s, ����878 OTUs, ȥ��320 chimeras
    # time ${db}/win/usearch -cluster_otus temp/uniques.fa \
    #  -otus temp/otus.fa \
    #  -relabel OTU_

    #����2. ASVȥ�� Denoise: predict biological sequences and filter chimeras
    #59s, 2920 good, 227 chimeras
    time ${db}/win/usearch -unoise3 temp/uniques.fa \
      -zotus temp/zotus.fa
    #�޸���������ZotuΪ��ΪASV����ʶ��
    sed 's/Zotu/ASV_/g' temp/zotus.fa > temp/otus.fa
    head -n 2 temp/otus.fa

    #����3. ���ݹ����޷�ʹ��usearchʱ����ѡvsearch������"��������3"

### 4.3 ���ڲο�ȥǶ�� Reference-based chimera detect

    # ���Ƽ���������������ԣ���Ϊ�ο����ݿ��޷����Ϣ��
    # ��de novoʱҪ���ױ����ΪǶ����16�����Ϸ�ֹ������
    # ��Ϊ��֪���в��ᱻȥ�������ݿ�ѡ��Խ��Խ���������������
    mkdir -p result/raw

    # ����1. vsearch+rdpȥǶ��(�쵫���׼�����)����
    # silvaȥǶ��(silva_16s_v123.fa)���Ƽ�(������ʱ15m ~ 3h��������)
    time ${db}/win/vsearch --uchime_ref temp/otus.fa \
      -db ${db}/usearch/rdp_16s_v16_sp.fa \
      --nonchimeras result/raw/otus.fa
    # RDP: 51s, 250 (8.6%) chimeras; SILVA��10m, 255 (8.7%) chimeras
    # Win vsearch��������windows���з�^M��ɾ����mac��Ҫִ�д�����
    sed -i 's/\r//g' result/raw/otus.fa

    # ����2. ��ȥǶ��
    cp -f temp/otus.fa result/raw/otus.fa


## 5. �������ɸѡ Feature table

    # OTU��ASVͳ��Ϊ����(Feature)�����ǵ������ǣ�
    # OTUͨ����97%�������ѡ��߷�Ȼ����ĵĴ��������У�
    # ASV�ǻ������н���ȥ��(�ų���У���������У�����ѡ��ȽϸߵĿ�������)��Ϊ����������

### 5.1 ���������� Creat Feature table

    # ����1. usearch����������С����(<30)�죻�������������Ҷ��߳�Ч�ʵͣ�84.1%, 4��1m
    # time ${db}/win/usearch -otutab temp/filtered.fa -otus result/raw/otus.fa \
    #   -otutabout result/raw/otutab.txt -threads 4

    # ����2. vsearch����������
    time ${db}/win/vsearch --usearch_global temp/filtered.fa --db result/raw/otus.fa \
    	--otutabout result/raw/otutab.txt --id 0.97 --threads 4
    #652036 of 761432 (85.63%)�ɱȶԣ���ʱ9m
    # windows�û�ɾ�����з�^M
    sed -i 's/\r//' result/raw/otutab.txt
    head -n3 result/raw/otutab.txt |cat -A


### 5.2 ����ע��-ȥ������ͷ�ϸ��/�ž���ͳ�Ʊ���(��ѡ) Remove plastid and non-Bacteria

    # RDP����ע��(rdp_16s_v16_sp)���죬��ȱ�����������Դ����,���ܲ���������ʱ15s;
    # SILVA���ݿ�(silva_16s_v123.fa)����ע����ˡ��������У�3h
    time ${db}/win/vsearch --sintax result/raw/otus.fa --db ${db}/usearch/rdp_16s_v16_sp.fa \
      --tabbedout result/raw/otus.sintax --sintax_cutoff 0.6

    # ԭʼ����������
    wc -l result/raw/otutab.txt
    #R�ű�ѡ��ϸ���ž�(���)��ȥ��Ҷ���塢�����岢ͳ�Ʊ��������ɸѡ�������OTU��
    #����ΪOTU��result/raw/otutab.txt������ע��result/raw/otus.sintax
    #���ɸѡ�������������result/otutab.txt��
    #ͳ����Ⱦ�����ļ�result/raw/otutab_nonBac.txt�͹���ϸ��otus.sintax.discard
    #���ITS���ݣ������otutab_filter_nonFungi.R�ű���ֻɸѡ���
    #��������Ϊ��taxonomy���ɹ��˵Ĳ������ʺ�ϸ�������
    Rscript ${db}/script/otutab_filter_nonBac.R -h
    Rscript ${db}/script/otutab_filter_nonBac.R \
      --input result/raw/otutab.txt \
      --taxonomy result/raw/otus.sintax \
      --output result/otutab.txt\
      --stat result/raw/otutab_nonBac.stat \
      --discard result/raw/otus.sintax.discard
    # ɸѡ������������
    wc -l result/otutab.txt

    #�����������Ӧ����
    cut -f 1 result/otutab.txt | tail -n+2 > result/otutab.id
    ${db}/win/usearch -fastx_getseqs result/raw/otus.fa \
        -labels result/otutab.id -fastaout result/otus.fa
    #�����������Ӧ����ע��
    awk 'NR==FNR{a[$1]=$0}NR>FNR{print a[$1]}'\
        result/raw/otus.sintax result/otutab.id \
        > result/otus.sintax
    #����ĩβ��
    sed -i 's/\t$/\td:Unassigned/' result/otus.sintax
    # head -n2 result/otus.sintax

    # ����2. ����ɸѡ��������Բ�ɸѡ
    # cp result/raw/otu* result/

    #��ѡͳ�Ʒ�����OTU���ͳ�� Summary OTUs table
    ${db}/win/usearch -otutab_stats result/otutab.txt \
      -output result/otutab.stat
    cat result/otutab.stat
    #ע����Сֵ����λ������鿴result/raw/otutab_nonBac.stat��������ϸ�������������ز���

### 5.3 ����������׼�� normlize by subsample

    #ʹ��vegan�����е����س���������reads count��ʽFeature��result/otutab.txt
    #��ָ�������ļ�����������������������ƽ��result/otutab_rare.txt�Ͷ�����alpha/vegan.txt
    mkdir -p result/alpha
    Rscript ${db}/script/otutab_rare.R --input result/otutab.txt \
      --depth 32000 --seed 1 \
      --normalize result/otutab_rare.txt \
      --output result/alpha/vegan.txt
    ${db}/win/usearch -otutab_stats result/otutab_rare.txt \
      -output result/otutab_rare.stat
    cat result/otutab_rare.stat


## 6. Alpha������ Alpha diversity

### 6.1. ���������ָ�� Calculate alpha diversity index
    #Calculate all alpha diversity index(Chao1�д�������)
    #details in http://www.drive5.com/usearch/manual/alpha_metrics.html
    ${db}/win/usearch -alpha_div result/otutab_rare.txt \
      -output result/alpha/alpha.txt

### 6.2. ����ϡ�͹��̵ķḻ�ȱ仯 Rarefaction
    #ϡ�����ߣ�ȡ1%-100%��������OTUs������20s
    #Rarefaction from 1%, 2% .. 100% in richness (observed OTUs)-method fast / with_replacement / without_replacement https://drive5.com/usearch/manual/cmd_otutab_subsample.html
    time ${db}/win/usearch -alpha_div_rare result/otutab_rare.txt \
      -output result/alpha/alpha_rare.txt -method without_replacement

### 6.3. ɸѡ����߷�Ⱦ����ڱȽ�

    #����������ľ�ֵ��������������ֵ�������ʵ�����metadata.txt�޸�������
    #�����ļ�Ϊfeautre��result/otutab.txt��ʵ�����metadata.txt
    #���Ϊ��������ľ�ֵ-һ��ʵ������ж��ַ��鷽ʽ
    Rscript ${db}/script/otu_mean.R --input result/otutab.txt \
      --design result/metadata.tsv \
      --group Group --thre 0 \
      --output result/otutab_mean.txt
    head -n3 result/otutab_mean.txt

    #����ƽ�����Ƶ�ʸ���ǧ��֮һ(0.1%)Ϊɸѡ��׼���õ�ÿ�����OTU���
    awk 'BEGIN{OFS=FS="\t"}{if(FNR==1) {for(i=2;i<=NF;i++) a[i]=$i;} \
        else {for(i=2;i<=NF;i++) if($i>0.1) print $1, a[i];}}' \
        result/otutab_mean.txt > result/alpha/otu_group_exist.txt
    head result/alpha/otu_group_exist.txt
    # �������ֱ����http://www.ehbio.com/ImageGP����Venn��upSetView��Sanky


## 7. Beta������ Beta diversity

    #����ж���ļ�����ҪĿ¼
    mkdir -p result/beta/
    #����OTU���������� Make OTU tree, 30s
    time ${db}/win/usearch -cluster_agg result/otus.fa -treeout result/otus.tree
    #����5�־������bray_curtis, euclidean, jaccard, manhatten, unifrac, 3s
    time ${db}/win/usearch -beta_div result/otutab_rare.txt -tree result/otus.tree \
      -filename_prefix result/beta/ # 1s


## 8. ����ע�ͽ��������� Taxonomy summary

    #OTU��Ӧ����ע��2�и�ʽ��ȥ��sintax������ֵ��ֻ��������ע�ͣ��滻:Ϊ_��ɾ������
    cut -f 1,4 result/otus.sintax \
      |sed 's/\td/\tk/;s/:/__/g;s/,/;/g;s/"//g;s/\/Chloroplast//' \
      > result/taxonomy2.txt
    head -n3 result/taxonomy2.txt

    #OTU��Ӧ����8�и�ʽ��ע��ע���Ƿ�����
    #�������ֱ��OTU/ASV�пհײ���ΪUnassigned
    awk 'BEGIN{OFS=FS="\t"}{delete a; a["k"]="Unassigned";a["p"]="Unassigned";a["c"]="Unassigned";a["o"]="Unassigned";a["f"]="Unassigned";a["g"]="Unassigned";a["s"]="Unassigned";\
      split($2,x,";");for(i in x){split(x[i],b,"__");a[b[1]]=b[2];} \
      print $1,a["k"],a["p"],a["c"],a["o"],a["f"],a["g"],a["s"];}' \
      result/taxonomy2.txt > temp/otus.tax
    sed 's/;/\t/g;s/.__//g;' temp/otus.tax|cut -f 1-8 | \
      sed '1 s/^/OTUID\tKingdom\tPhylum\tClass\tOrder\tFamily\tGenus\tSpecies\n/' \
      > result/taxonomy.txt
    head -n3 result/taxonomy.txt

    #ͳ���Ÿ�Ŀ������ʹ�� rank���� p c o f g��Ϊphylum, class, order, family, genus��д
    mkdir -p result/tax
    for i in p c o f g;do
      ${db}/win/usearch -sintax_summary result/otus.sintax \
      -otutabin result/otutab_rare.txt -rank ${i} \
      -output result/tax/sum_${i}.txt
    done
    sed -i 's/(//g;s/)//g;s/\"//g;s/\#//g;s/\/Chloroplast//g' result/tax/sum_*.txt
    # �г������ļ�
    ls -sh result/tax/sum_*.txt
    head -n3 result/tax/sum_g.txt


## 9. �вαȶԡ�������Ԥ�⣬��Greengene��������picurst, bugbase����

    mkdir -p result/gg/
    #��GG����97% OTUs�ȶԣ����ڹ���Ԥ��

    #����1. usearch�ȶԸ��죬���ļ����ޱ���ѡ����2
    time ${db}/win/usearch -otutab temp/filtered.fa -otus ${db}/gg/97_otus.fasta \
    	-otutabout result/gg/otutab.txt -threads 4
    #79.9%, 4��ʱ8m
    head -n3 result/gg/otutab.txt

    # #����2. vsearch�ȶԣ���׼�������������и�ǿ
    # time ${db}/win/vsearch --usearch_global temp/filtered.fa --db ${db}/gg/97_otus.fasta \
    #   --otutabout result/gg/otutab.txt --id 0.97 --threads 12
    #80.9%, 12cores 20m, 1core 1h, 594Mb

    #ͳ��
    ${db}/win/usearch -otutab_stats result/gg/otutab.txt -output result/gg/otutab.stat
    cat result/gg/otutab.stat


## 10. �ռ����������ύ

    #ɾ���м���ļ�
    rm -rf temp/*.fq
    #ԭʼ���ݼ�ʱѹ����ʡ�ռ䲢�ϴ��������ı���, 54s
    gzip seq/*

    # ��˫��ͳ��md5ֵ�����������ύ
    cd seq
    md5sum *_1.fq.gz > md5sum1.txt
    md5sum *_2.fq.gz > md5sum2.txt
    paste md5sum1.txt md5sum2.txt | awk '{print $2"\t"$1"\t"$4"\t"$3}' | sed 's/*//g' > ../result/md5sum.txt
    rm md5sum*
    cd ..
    cat result/md5sum.txt



# 23��R���Զ����Ժ����ַ���


## 1. Alpha������

### 1.1 Alpha����������ͼ
    # �鿴����
    Rscript ${db}/script/alpha_boxplot.R -h
    # ����������������ָ����ѡrichness chao1 ACE shannon simpson invsimpson
    Rscript ${db}/script/alpha_boxplot.R --alpha_index richness \
      --input result/alpha/vegan.txt --design result/metadata.tsv \
      --group Group --output result/alpha/ \
      --width 89 --height 59
    # ʹ��ѭ������6�ֳ���ָ��
    for i in `head -n1 result/alpha/vegan.txt|cut -f 2-`;do
      Rscript ${db}/script/alpha_boxplot.R --alpha_index ${i} \
        --input result/alpha/vegan.txt --design result/metadata.tsv \
        --group Group --output result/alpha/ \
        --width 89 --height 59
    done

### 1.2 ϡ������
    Rscript ${db}/script/alpha_rare_curve.R \
      --input result/alpha/alpha_rare.txt --design result/metadata.tsv \
      --group Group --output result/alpha/ \
      --width 89 --height 59

### 1.3 ������ά��ͼ
    # ����Ƚ�:-f�����ļ�,-a/b/c/d/g������,-w/uΪ���Ӣ��,-p����ļ�����׺
    bash ${db}/script/sp_vennDiagram.sh \
      -f result/alpha/otu_group_exist.txt \
      -a WT -b KO -c OE \
      -w 3 -u 3 \
      -p WT_KO_OE
    # ����Ƚϣ�ͼ�ʹ���������ļ�Ŀ¼������Ŀ¼Ϊ��ǰ��Ŀ��Ŀ¼
    bash ${db}/script/sp_vennDiagram.sh \
      -f result/alpha/otu_group_exist.txt \
      -a WT -b KO -c OE -d All \
      -w 3 -u 3 \
      -p WT_KO_OE_All

## 2. Beta������

### 2.1 ���������ͼpheatmap
    # ��bray_curtisΪ����-f�����ļ�,-h�Ƿ����TRUE/FALSE,-u/vΪ���Ӣ��
    bash ${db}/script/sp_pheatmap.sh \
      -f result/beta/bray_curtis.txt \
      -H 'TRUE' -u 5 -v 5
    # ��ӷ���ע�ͣ���2��4�еĻ����ͺ͵ص�
    cut -f 1-2 result/metadata.tsv > temp/group.txt
    # -P�����ע���ļ���-Q�����ע��
    bash ${db}/script/sp_pheatmap.sh \
      -f result/beta/bray_curtis.txt \
      -H 'TRUE' -u 8.9 -v 5.6 \
      -P temp/group.txt -Q temp/group.txt
    # ���������������ƣ��ɳ���corrplot��ggcorrplot���Ƹ�����ʽ
    # - [��ͼ���ϵ������corrplot](http://mp.weixin.qq.com/s/H4_2_vb2w_njxPziDzV4HQ)
    # - [��ؾ�����ӻ�ggcorrplot](http://mp.weixin.qq.com/s/AEfPqWO3S0mRnDZ_Ws9fnw)

### 2.2 ���������PCoA
    # �����ļ���ѡ����飬����ļ���ͼƬ�ߴ�mm��ͳ�Ƽ�beta_pcoa_stat.txt
    Rscript ${db}/script/beta_pcoa.R \
      --input result/beta/bray_curtis.txt --design result/metadata.tsv \
      --group Group --output result/beta/bray_curtis.txt.pcoa.pdf \
      --width 89 --height 59

### 2.3 ���������������CPCoA
    Rscript ${db}/script/beta_cpcoa.R \
      --input result/beta/bray_curtis.txt --design result/metadata.tsv \
      --group Group --output result/beta/bray_curtis.txt.cpcoa.pdf \
      --width 89 --height 59

## 3. �������Taxonomy

### 3.1 �ѵ���״ͼStackplot
    # ����(p)ˮƽΪ�����������output.sample/group.pdf�����ļ�
    Rscript ${db}/script/tax_stackplot.R \
      --input result/tax/sum_p.txt --design result/metadata.tsv \
      --group Group --output result/tax/sum_p.stackplot \
      --legend 5 --width 89 --height 59
    # ���������������p/c/o/f/g��5��
    for i in p c o f g; do
    Rscript ${db}/script/tax_stackplot.R \
      --input result/tax/sum_${i}.txt --design result/metadata.tsv \
      --group Group --output result/tax/sum_${i}.stackplot \
      --legend 8 --width 89 --height 59; done

### 3.2 ��ͼ(Ȧͼ)circlize
    # �Ը�(class,c)Ϊ��������ǰ5��
    i=c
    Rscript ${db}/script/tax_circlize.R \
      --input result/tax/sum_${i}.txt --design result/metadata.tsv \
      --group Group --legend 5
    # ���λ�ڵ�ǰĿ¼circlize.pdf(�����ɫ)��circlize_legend.pdf(ָ����ɫ+ͼ��)
    # �ƶ�����������༶һ��
    mv circlize.pdf result/tax/sum_${i}.circlize.pdf
    mv circlize_legend.pdf result/tax/sum_${i}.circlize_legend.pdf

### 3.3 ��ͼtreemap/maptree
    # ��㼶�������ֹ�ϵ�����������������ע�ͣ������ͼ��ָ����������������ͼƬ���
    Rscript ${db}/script/tax_maptree.R \
      --input result/otutab.txt --taxonomy result/taxonomy.txt \
      --output result/tax/tax_maptree.pdf \
      --topN 200 --width 183 --height 118

# 24������Ƚ�

## 24-1. R���Բ������

### 1.1 ����Ƚ�Difference comparison
    mkdir -p result/compare/
    # ����������Ԫ���ݣ�ָ�������������Ƚ���ͷ��
    # ѡ�񷽷�wilcox/t.test/edgeR��pvalue��fdr�����Ŀ¼
    compare="KO-WT"
    Rscript ${db}/script/compare.R \
      --input result/otutab.txt --design result/metadata.tsv \
      --group Group --compare ${compare} --threshold 0.1 \
      --method edgeR --pvalue 0.05 --fdr 0.2 \
      --output result/compare/

### 1.2 ��ɽͼ
    # ����compare.R�Ľ���������ɽͼ�����ݱ�ǩ����ָ��ͼƬ��С
    Rscript ${db}/script/compare_volcano.R \
      --input result/compare/${compare}.txt \
      --output result/compare/${compare}.txt.volcano.pdf
      --width 89 --height 59

### 1.3 ��ͼ
    # ����compare.R�Ľ����ɸѡ������ָ��Ԫ���ݺͷ��顢����ע�ͣ�ͼ��СӢ����ֺ�
    bash ${db}/script/compare_heatmap.sh -i result/compare/${compare}.txt -l 7 \
       -d result/metadata.tsv -A Group \
       -t result/taxonomy.txt \
       -w 8 -h 5 -s 7 \
       -o result/compare/${compare}.txt

### 1.4 ������ͼ
    # i����ȽϽ��,t����ע��,pͼ��,w��,v��,s�ֺ�,lͼ�����ֵ
    bash ${db}/script/compare_manhattan.sh -i result/compare/${compare}.txt \
       -t result/taxonomy.txt \
       -p result/tax/sum_p.txt \
       -w 183 -v 59 -s 7 -l 10 \
       -o result/compare/${compare}
    # ��ͼֻ��6���ţ��л�Ϊ��c��-L Classչʾϸ��
    bash ${db}/script/compare_manhattan.sh -i result/compare/${compare}.txt \
       -t result/taxonomy.txt \
       -p result/tax/sum_c.txt \
       -w 130 -v 59 -s 7 -l 10 -L Class \
       -o result/compare/${compare}.txt

## 24-2. STAMP�����ļ�׼��

### 2.1 ���������������ļ�
    Rscript ${db}/script/format2stamp.R -h
    mkdir -p result/stamp
    Rscript ${db}/script/format2stamp.R --input result/otutab.txt \
      --taxonomy result/taxonomy.txt --threshold 0.1 \
      --output result/stamp/tax

### 2.2 Rmd���������ļ�
    #1. 24compare/stampĿ¼��׼��otutab.txt��taxonomy.txt�ļ���
    #2. Rstudio��format2stamp.Rmd�����ò�����
    #3. ���Knit�ڵ�ǰĿ¼����stamp�����ļ��Ϳ��ظ�������ҳ��


## 24-3. LEfSe�����ļ�׼��

### 3.1. �����������ļ�

    # ��ѡ���������������ļ�
    Rscript ${db}/script/format2lefse.R -h
    Rscript ${db}/script/format2lefse.R --input result/otutab.txt \
      --taxonomy result/taxonomy.txt --design result/metadata.tsv \
      --group Group --threshold 0.1 \
      --output result/LEfSe

### 3.2 Rmd���������ļ�
    #1. 24Compare/LEfSeĿ¼��׼��otutab.txt, metadata.tsv, taxonomy.txt�����ļ���
    #2. Rstudio��format2lefse.Rmd��Knit���������ļ��Ϳ��ظ�������ҳ��

### 3.3 LEfSe����
    #����1. ��LEfSe.txt�������ύ http://www.ehbio.com/ImageGP/index.php/Home/Index/LEFSe.html
    #����2. LEfSe���ط���(��Linux��������ѡѧ)���ο��������¼
    #����3. LEfSe��������ʹ��



# 25��QIIME 2��������
    # ������� 25QIIME2/pipeline_qiime2.sh



# 31������Ԥ��


## 1. PICRUSt����Ԥ��

    # �Ƽ�ʹ�� http://www.ehbio.com/ImageGP ���߷��� gg/otutab.txt
    # Ȼ����ʹ��STAMP/R���в���Ƚ�
    # ��Linux�������û��ɲο���¼2������������

## 2. Ԫ��ѭ��FAPROTAX

    ## ����1. ���߷������Ƽ�ʹ�� http://www.ehbio.com/ImageGP ���߷���
    ## ����2. Linux�·�����ѡѧ�������¼3

## 3. Bugbaseϸ������Ԥ��


### 1. Bugbase�����з���
    bugbase=${db}/script/BugBase
    rm -rf result/bugbase/
    Rscript ${bugbase}/bin/run.bugbase.r -L ${bugbase} \
      -i result/gg/otutab.txt -m result/metadata.tsv -c Group -o result/bugbase/

### 2. �������÷���
    # ʹ�� http://www.ehbio.com/ImageGP
    # ������https://bugbase.cs.umn.edu/ ���б������Ƽ�
    # Bugbaseϸ������Ԥ��Linux�������¼4. Bugbaseϸ������Ԥ��



# 33��MachineLearning����ѧϰ

    # RandomForest��ʹ�õ�R�����33MachineLearningĿ¼�е�RF_classification��RF_regression
    ## Silme2���ɭ��/Adaboostʹ�ô����33MachineLearningĿ¼�е�slime2����¼5


# 34. Evolution������

    cd ${wd}
    mkdir -p result/tree
    cd ${wd}/result/tree

## 1. ɸѡ�߷�ȡ�ָ��ASV����

    #����1. �����ɸѡ��ɸѡ���߷��OTU��һ��ѡ0.001��0.005����OTU������30-150����Χ��
    #ͳ��OTU����OTU���������ܼ�2631��
    tail -n+2 ../otutab_rare.txt | wc -l
    #����Է��0.2%ɸѡ�߷��OTU
    ${db}/win/usearch -otutab_trim ../otutab_rare.txt \
        -min_otu_freq 0.002 \
        -output otutab.txt
    #ͳ��ɸѡOTU�������������ܼ�80��
    tail -n+2 otutab.txt | wc -l
    #��ȡID������ȡ����
    cut -f 1 otutab.txt | sed '1 s/#OTU ID/OTUID/' > otutab_high.id

    #����2. ������ɸѡ
    #���������Ĭ���ɴ�С
    ${db}/win/usearch -otutab_sortotus ../otutab_rare.txt  \
        -output otutab_sort.txt
    #��ȡ�߷����ָ��Top������OTU ID����Top100,
    sed '1 s/#OTU ID/OTUID/' otutab_sort.txt \
        | head -n101 > otutab.txt
    cut -f 1 otutab.txt > otutab_high.id

    #ɸѡ�߷�Ⱦ�/ָ���������ӦOTU����
    ${db}/win/usearch -fastx_getseqs ../otus.fa -labels otutab_high.id \
        -fastaout otus.fa
    head -n 2 otus.fa

    ## ɸѡOTU������ע��
    awk 'NR==FNR{a[$1]=$0} NR>FNR{print a[$1]}' ../taxonomy.txt \
        otutab_high.id > otutab_high.tax

    #���OTU��Ӧ���ֵ������������ͼ
    #����֮ǰotu_mean.R�������Group����ľ�ֵ
    awk 'NR==FNR{a[$1]=$0} NR>FNR{print a[$1]}' ../otutab_mean.txt otutab_high.id \
        | sed 's/#OTU ID/OTUID/' > otutab_high.mean
    head -n3 otutab_high.mean

    #�ϲ�����ע�ͺͷ��Ϊע���ļ�
    cut -f 2- otutab_high.mean > temp
    paste otutab_high.tax temp > annotation.txt
    head -n 3 annotation.txt


## 2. ����������

    # ��ʼ�ļ�Ϊ result/treeĿ¼�� otus.fa(����)��annotation.txt(���ֺ���Է��)�ļ�
    # Muscle����������ж��룬3s
	  time muscle -in otus.fa -out otus_aligned.fas

    ### ����1. ����IQ-TREE���ٹ���ML��������2m
    mkdir -p iqtree
    time ${db}/win/iqtree -s otus_aligned.fas \
        -bb 1000 -redo -alrt 1000 -nt AUTO \
        -pre iqtree/otus

    ### ����2. FastTree���ٽ���(Linux)
    # ע��FastTree��������ļ�Ϊfasta��ʽ���ļ���������ͨ���õ�Phylip��ʽ������ļ���Newick��ʽ��
    # �÷����ʺ��ڴ����ݣ����缸�ٸ�OTUs��ϵͳ��������
    # Ubuntu�ϰ�װfasttree����ʹ��`apt install fasttree`
    # fasttree -gtr -nt otus_aligned.fa > otus.nwk


## 3. ����������

    # ����http://itol.embl.de/���ϴ�otus.nwk������ק�·����ɵ�ע�ͷ��������ϼ�����

    ## ����1. ��Ȧ��ɫ����״����ͷ�ȷ���
    # annotation.txt OTU��Ӧ����ע�ͺͷ�ȣ�
    # -a �Ҳ��������н���ֹ���У�Ĭ�ϲ�ִ�У�-c ��������ת��Ϊfactor�����С��������֣�-t ƫ����ʾ��ǩʱת��ID�У�-w ��ɫ���������ȵȣ� -D���Ŀ¼��-i OTU������-l OTU��ʾ��������/��/������
    # cd ${wd}/result/tree
    Rscript ${db}/script/table2itol.R -a -c double -D plan1 -i OTUID -l Genus -t %s -w 0.5 annotation.txt
    # ����ע���ļ���ÿ��Ϊ����һ���ļ�

    ## ����2. ���ɷ������ͼע���ļ�
    Rscript ${db}/script/table2itol.R -a -d -c none -D plan2 -b Phylum -i OTUID -l Genus -t %s -w 0.5 annotation.txt

    ## ����3. ������ͼע���ļ�
    Rscript ${db}/script/table2itol.R -c keep -D plan3 -i OTUID -t %s otutab.txt

    ## ����4. ������ת������������ע���ļ�
    Rscript ${db}/script/table2itol.R -a -c factor -D plan4 -i OTUID -l Genus -t %s -w 0 annotation.txt

    # ���ع���Ŀ¼
    cd ${wd}


# ��¼��Linux�������·���(ѡѧ)

    #ע��Windows�¿����޷��������´��룬�Ƽ���Linux��conda��װ��س���

## 1. LEfSe����

    mkdir -p ~/amplicon/24Compare/LEfSe
    cd ~/amplicon/24Compare/LEfSe
    # format2lefse.Rmd�����������ϴ������ļ�LEfSe.txt
    # ��װlefse
    # conda install lefse

    #��ʽת��Ϊlefse�ڲ���ʽ
    lefse-format_input.py LEfSe.txt input.in -c 1 -o 1000000
    #����lefse
    run_lefse.py input.in input.res
    #����������ע�Ͳ���
    lefse-plot_cladogram.py input.res cladogram.pdf --format pdf
    #�������в���features��״ͼ
    lefse-plot_res.py input.res res.pdf --format pdf
    #���Ƶ���features��״ͼ(ͬSTAMP��barplot)
    head input.res #�鿴����features�б�
    lefse-plot_features.py -f one --feature_name "Bacteria.Firmicutes.Bacilli.Bacillales.Planococcaceae.Paenisporosarcina" \
       --format pdf input.in input.res Bacilli.pdf
    #�����������в���features��״ͼ������(�����Ų�������״ͼ�Ķ�Ҳ������)
    mkdir -p features
    lefse-plot_features.py -f diff --archive none --format pdf \
      input.in input.res features/


## 2. PICRUSt����Ԥ��

    #�Ƽ�ʹ�� http://www.ehbio.com/ImageGP ���߷���
    #��Linux�������û��ɲο����´�����������
    cd ~/amplicon/result
    mkdir -p picrust

    # ��װpicurst

    #�ϴ�gg/otutab.txt����ǰĿ¼
    #ת��ΪOTU��ͨ�ø�ʽ���������η�����ͳ��
    biom convert -i otutab.txt \
        -o otutab.biom \
        --table-type="OTU table" --to-json
    #У��������
    normalize_by_copy_number.py -i otutab.biom \
        -o otutab_norm.biom \
        -c /db/picrust/16S_13_5_precalculated.tab.gz
    #Ԥ��������KO��biom�������ι��࣬txt����鿴����
    predict_metagenomes.py -i otutab_norm.biom \
        -o ko.biom \
        -c /db/picrust/ko_13_5_precalculated.tab.gz
    predict_metagenomes.py -f -i otutab_rare.biom \
        -o ko.txt \
        -c /db/picrust/ko_13_5_precalculated.tab.gz

    #�����ܼ���������, -c���KEGG_Pathways����1-3��
    sed  -i '/#Constru/d;s/#OTU //' ko.txt
    num=`tail -n1 ko.txt|wc -w`
    for i in 1 2 3;do
      categorize_by_function.py -f -i ko.biom -c KEGG_Pathways -l ${i} -o ko${i}.txt
      sed  -i '/#Constru/d;s/#OTU //' ko${i}.txt
      paste <(cut -f $num ko${i}.txt) <(cut -f 1-$[num-1] ko${i}.txt) > ko${i}.spf
    done
    wc -l ko*.spf


## 3. FAPROTAXSԪ��ѭ��

    cd amplicon/result/faprotax

### 1. �����װ

    #�������1.1�棬 June 10, 2017�������ݿ�
    wget -c https://pages.uoregon.edu/slouca/LoucaLab/archive/FAPROTAX/SECTION_Download/MODULE_Downloads/CLASS_Latest%20release/UNIT_FAPROTAX_1.2/FAPROTAX_1.2.zip
    #��ѹ
    unzip FAPROTAX_1.2.zip

    #�����Ƿ�����У�������������������
    python FAPROTAX_1.2/collapse_table.py

    #�������һ����ʾȱ��numpy����ʹ��conda��װ������
    conda install numpy
    conda install biom

### 2. ��������OTU��

    #txtת��Ϊbiom json��ʽ
    biom convert -i otutab_rare.txt -o otutab_rare.biom --table-type="OTU table" --to-json
    #�������ע��
    biom add-metadata -i otutab_rare.biom --observation-metadata-fp taxonomy2.txt \
      -o otutab_rare_tax.biom --sc-separated taxonomy \
      --observation-header OTUID,taxonomy
    #ָ�������ļ�������ע�͡�����ļ���ע����������������

### 3. FAPROTAX����Ԥ��

    #python����collapse_table.py�ű��������������ע��OTU��tax.biom��
    #-gָ�����ݿ�λ�ã�����ע�����������������Ϣ��ǿ�Ƹ��ǽ��������ļ���ϸ��
    #����faprotax.txt�����ʵ����ƿɽ���ͳ�Ʒ���
    #faprotax_report.txt�鿴ÿ������о�����Դ��ЩOTUs
    python FAPROTAX_1.2/collapse_table.py -i otutab_rare_tax.biom \
      -g FAPROTAX_1.2/FAPROTAX.txt \
      --collapse_by_metadata 'taxonomy' -v --force \
      -o faprotax.txt -r faprotax_report.txt

### 4. ����OTU��Ӧ����ע�����޾���

    # ��OTUע���У���ǰһ�б������ɸѡ
    grep 'ASV_' -B 1 faprotax_report.txt | grep -v -P '^--$' > faprotax_report.clean
    # ɸѡPerl�ű�����������Ϊ��������ҵ�github(YongxinLiu)��32FAPROTAXĿ¼
    ./faprotax_report_sum.pl -i faprotax_report.clean -o faprotax_report
    # �鿴�������޾���-S������
    less -S faprotax_report.mat

## 4. Bugbaseϸ������Ԥ��

### 1. �����װ(��һ��)

    #�����ַ�����ѡ���Ƽ���һ�֣���ѡ�ڶ��֣���������һ��

    #����1. git���أ���Ҫ��git
    git clone https://github.com/knights-lab/BugBase

    #����2. ���ز���ѹ
    wget https://github.com/knights-lab/BugBase/archive/master.zip
    mv master.zip BugBase.zip
    unzip BugBase.zip
    mv BugBase-master/ BugBase

    #��װ������
    cd BugBase
    export BUGBASE_PATH=`pwd`
    export PATH=$PATH:`pwd`/bin
    #��װ������������
    run.bugbase.r -h
    #��������
    run.bugbase.r -i doc/data/HMP_s15.txt -m doc/data/HMP_map.txt -c HMPBODYSUBSITE -o output


### 2. ׼�������ļ�

    cd ~/amplicon/result
    #�����ļ�������greengene OTU���biom��ʽ(���ط���֧��txt��ʽ����ת��)��mapping file(metadata.tsv�������#)
    #�ϴ�ʵ�����+�ղ����ɵ�otutab_gg.txt
    #�������߷���ʹ�õ�biom1.0��ʽ
    biom convert -i gg/otutab.txt -o otutab_gg.biom --table-type="OTU table" --to-json
    sed '1 s/^/#/' metadata.tsv > MappingFile.txt
    #����otutab_gg.biom �� MappingFile.txt�������߷���

### 3. ���ط���

    export BUGBASE_PATH=`pwd`
    export PATH=$PATH:`pwd`/bin
    run.bugbase.r -i otutab_gg.txt -m MappingFile.txt -c Group -o phenotype/

## 5. Silme2���ɭ��/Adaboost

    #���ذ�װ
    cd ~/software/
    wget https://github.com/swo/slime2/archive/master.zip
    mv master.zip slime2.zip
    unzip slime2.zip
    mv slime2-master/ slime2
    cp slime2/slime2.py ~/bin/
    chmod +x ~/bin/slime2.py

    #��װ������
    sudo pip3 install --upgrade pip
    sudo pip3 install pandas
    sudo pip3 install sklearn

    # ʹ��ʵս
    cd 33MachineLearning/slime2
    #ʹ��adaboost����10000��(16.7s)���Ƽ�ǧ���
    ./slime2.py otutab.txt design.txt --normalize --tag ab_e4 ab -n 10000
    #ʹ��RandomForest����10000��(14.5s)���Ƽ�����Σ�֧�ֶ��߳�
    ./slime2.py otutab.txt design.txt --normalize --tag rf_e4 rf -n 10000
    cd ../../




# ��������

## 1. �ļ�phred�������󡪡�Fastq����ֵ64ת33

    #�鿴64λ��ʽ�ļ�������ֵ��ΪСд��ĸ
    head -n4 FAQ/Q64Q33/test_64.fq
    #ת������ֵ64�����ʽΪ33
    vsearch --fastq_convert FAQ/Q64Q33/test_64.fq \
        --fastqout FAQ/test.fq \
        --fastq_ascii 64 --fastq_asciiout 33
    #�鿴ת����33�����ʽ������ֵ��Ϊ��д��ĸ
    head -n4 FAQ/test.fq

## 2. ����˫���Ѿ��ϲ�������������������/���������

    #�鿴�ļ�������
    head -n1 FAQ/test.fq
    #���а���������������������ļ���
    mkdir -p FAQ/relabel
    vsearch --fastq_convert FAQ/test.fq \
        --fastqout FAQ/relabel/WT1.fq --relabel WT1.
    #�鿴ת����33�����ʽ������ֵ��Ϊ��д��ĸ
    head -n1 FAQ/relabel/WT1.fq

## 3. ���ݹ����޷�ʹ��usearch�����ȥ��-vsearch

    #��ѡvsearch����OTU�������Զ�de novoȥǶ�Ϲ���
    #����usearch��Ѱ�����ʱ(��ͨ�����minuniquesize��������������)ʹ�ã����Ƽ�
    #������������97%�������Σ���������count
    vsearch --cluster_size temp/uniques.fa  \
     --centroids temp/otus.fa \
     --relabel OTU_ --id 0.97 --qmask none --sizein --sizeout
    #5s Clusters: 1062
    #vsearch��������--uchime3_denovo


## 4. Reads count����ֵ��α�׼��Ϊ��Է��

    #��ȡ����OTU�ڶ�Ӧ��Ʒ�ķ��Ƶ��
    usearch -otutab_counts2freqs result/otutab_rare.txt \
        -output result/otutab_rare_freq.txt

## 5. ����R��ʾwrite.table Permission denied

    #���籨����Ϣʾ�����£�
    Error in file(file, ifelse(append, "a", "w")) :
    Calls: write.table -> file
    : Warning message:
    In file(file, ifelse(append, "a", "w")) :
      'result/raw/otutab_nonBac.txt': Permission denied
    #����Ϊд���ļ���Ȩ�ޣ�һ��ΪĿ���ļ����ڱ��򿪣���ر�����

## 6. �ļ���������

    # ע���޸�·��
    cd /c/project/seq
    ls > ../filelist.txt
    # �༭�б��ڶ���Ϊ����������ȷ������Ψһ
    # ����ֶ������Ƿ�Ψһ
    cut -f 2 ../filelist.txt |wc -l
    cut -f 2 ../filelist.txt | sort | uniq |wc -l
    # ������ν��һ�£�������������
    awk '{system("mv "$1" "$2)}' ../filelist.txt

## 7. Rstudio��Terminal�Ҳ���Linux����

    # ��Ҫ�� C:\Program Files\Git\usr\bin Ŀ¼��ӵ�ϵͳ��������
    # ע��win10ϵͳ��һ��Ŀ¼һ�У�win7�ж��Ŀ¼�÷ֺŷָ���ע��������Ŀ¼


## 8. ���Ծ�ֵ��ʧ��
    cd /c/amplicon/FAQ/merge
    #�������ֵ�������ʵ�����metadata.txt�޸�������
    #�����ļ�Ϊfeautre��result/otutab.txt��ʵ�����metadata.txt
    #���Ϊ��������ľ�ֵ-һ��ʵ������ж��ַ��鷽ʽ
    Rscript /c/amplicon/22Pipeline/script/otu_mean.R

    #����ƽ�����Ƶ�ʸ���0.05%Ϊɸѡ��׼���õ�ÿ�����OTU���
    awk 'BEGIN{OFS=FS="\t"}{if(FNR==1) {for(i=2;i<=NF;i++) a[i]=$i;} \
        else {for(i=2;i<=NF;i++) if($i>0.05) print $1, a[i];}}' \
        result/otutab_mean_Genotype.txt > alpha/otu_group_exist.txt
    # �������ֱ����http://www.ehbio.com/ImageGP����Venn��upSetView��Sanky

## 9. usearch/vsearch ����OTU��ʱ�޷�ƥ��
    #��ԭʼ���з�����󣬽�������Ҫȡ���򻥲�
    vsearch --fastx_revcomp ../FAQ/filtered_test.fa \
      --fastaout ../FAQ/filtered_test_RC.fa
    # �ٷ���
    usearch -otutab ../FAQ/filtered_test_RC.fa -otus db/gg/97_otus.fasta \
    	-otutabout gg/otutab.txt -threads 6

## 10. ����ļ�windows���з���ɾ��

    cd /c/amplicon/FAQ/190614_ITS_taxSum_0field
  	i=g
    usearch -sintax_summary sintax.txt \
    -otutabin otutab_rare.txt \
    -rank ${i} \
    -output sum_${i}.txt
