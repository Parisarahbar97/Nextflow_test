//mapping.nf

nextflow.enable.dsl=2

params {
    cellranger_path = "/rds/general/user/pr422/home/PhD/cellranger/cellranger-8.0.1/cellranger"
    reference = "/rds/general/user/pr422/home/PhD/refrence_genome/mouse/refdata-gex-GRCm39-2024-A"
    base_dir = "/rds/general/user/pr422/home/PhD/DATA/epilep/mouse/hippo/1.Data"
    outdir = "/rds/general/user/pr422/home/PhD/DATA/epilep/mouse/hippo/output"
}

sample_channel = Channel
    .fromPath("${params.base_dir}/{1,2,3,4}/*/*.fastq.gz") // Locate all FASTQ files in subdirectories
    .map { file -> [ file.parent.name, file ] }            // Map each file to its sample directory
    .groupTuple()                                          // Group files by sample name


process map_sample {
    publishDir "${params.outdir}", mode: 'copy'           

    input:
    tuple val(sample_name), path(sample_files)            

    output:
    path "*"

    script:
    """  
    fastqs=\$(echo ${sample_files[*]} | tr ' ' ',')

    ${params.cellranger_path} count \\
        --id=${sample_name}_count \\
        --transcriptome=${params.reference} \\
        --fastqs=${fastqs} \\
        --sample=${sample_name}
    """
}

workflow {
    map_sample(sample_channel) 
}
