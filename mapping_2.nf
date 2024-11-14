nextflow.enable.dsl=2

params.cellranger_path
params.reference
params.sample_dir 
params.outdir

sample_channel = Channel.of("S17R")

process map_sample {
    publishDir "${params.outdir}", mode: 'copy'

    input:
    val sample_name

    output:
    path "*"

    script:
    """
   
    sample="${sample_name}"
    fastq_dir="${params.sample_dir}"

    ${params.cellranger_path} count \\
        --id=\${sample}_count \\
        --transcriptome=${params.reference} \\
        --fastqs=\${fastq_dir} \\
        --sample=1_S17R,2_S17R,3_S17R,4_S17R \\
        --create-bam=true
    """
}

workflow {
    map_sample(sample_channel)
}
