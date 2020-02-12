# Laplacian Anomaly Detector (LAD)

This is the code used in the article:

F. Verdoja and M. Grangetto, “Graph Laplacian for image anomaly detection,” Machine Vision and Applications, vol. 31, no. 1, Feb. 2020, doi: 10.1007/s00138-020-01059-4.

Article versions: [[published](https://link.springer.com/article/10.1007/s00138-020-01059-4)] [[preprint](https://arxiv.org/abs/1802.09843)] 

## Paper abstract

Reed–Xiaoli detector (RXD) is recognized as the benchmark algorithm for image anomaly detection; however, it presents known limitations, namely the dependence over the image following a multivariate Gaussian model, the estimation and inversion of a high-dimensional covariance matrix, and the inability to effectively include spatial awareness in its evaluation. In this work, a novel graph-based solution to the image anomaly detection problem is proposed; leveraging the graph Fourier transform, we are able to overcome some of RXD’s limitations while reducing computational cost at the same time. Tests over both hyperspectral and medical images, using both synthetic and real anomalies, prove the proposed technique is able to obtain significant gains over performance by other algorithms in the state of the art. 

## Dependencies

The code should run on any version of Matlab 2014+

## Use

`test_all.m` tests any of the implemented algorithms on any of the included testing scenarios.
