# Laplacian Anomaly Detector (LAD)

This is the code used in the article:

F. Verdoja and M. Grangetto, “Graph Laplacian for Image Anomaly Detection,” arXiv:1802.09843 [cs, eess], Feb. 2018.

Article versions: [[preprint](https://arxiv.org/abs/1802.09843)]

## Paper abstract

Reed-Xiaoli Detector (RXD) is recognized as the benchmark algorithm for image anomaly detection, however it presents known limitations, namely the dependence over the image following a multivariate Gaussian model, the estimation and inversion of a high dimensional covariance matrix and the inability to effectively include spatial awareness in its evaluation. In this work a novel graph-based solution to the image anomaly detection problem is proposed; leveraging on the Graph Fourier Transform, we are able to overcome some of RXD's limitations while reducing computational cost at the same time. Tests over both hyperspectral and medical images, using both synthetic and real anomalies, prove the proposed technique is able to obtain significant gains over performance by other algorithms in the state-of-the-art.

## Dependencies

The code should run on any version of Matlab 2014+

## Use

`test_all.m` tests any of the implemented algorithms on any of the included testing scenarios.
