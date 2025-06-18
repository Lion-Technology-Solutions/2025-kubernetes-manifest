First deploy - the ebs csi driver 

#    eksctl create addon --name aws-ebs-csi-driver --cluster class30 --region ca-central-1 --service-account-role-arn arn:aws:iam::267509235741:role/AmazonEKS_EBS_CSI_DriverRole --force



# replace your account number , clustername and region


first create : 

pv 
pvc 
then deployment
