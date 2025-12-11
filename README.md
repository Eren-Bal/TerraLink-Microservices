# 🚀 TerraLink Microservices: DevOps Infrastructure Project

Bu proje, **Infrastructure as Code (IaC)** prensipleri kullanılarak AWS üzerinde çalışan uçtan uca bir mikroservis mimarisidir.

## 🏗️ Mimari ve Teknolojiler

* **Cloud Provider:** AWS (EC2, Security Groups)
* **Infrastructure as Code:** Terraform
* **Containerization:** Docker & Docker Compose
* **CI/CD:** GitHub Actions (Full Automated Pipeline)
* **Backend:** Node.js (Express)
* **Frontend:** React
* **Database:** Redis

## ⚙️ Nasıl Çalışır?

1.  **Terraform**, AWS üzerinde gerekli sunucuyu ve ağ ayarlarını kurar.
2.  **GitHub Actions**, kodu otomatik test eder, Docker imajlarını build eder ve Docker Hub'a yükler.
3.  CI/CD hattı, AWS sunucusuna bağlanır ve kesinti olmadan yeni versiyonu yayına alır (Deployment).

## 🔒 Güvenlik
* Tüm hassas veriler (SSH Keys, Credentials) GitHub Secrets üzerinde şifreli olarak saklanmaktadır.
* Security Group ayarları sadece gerekli portlara (3000, 5000) izin verecek şekilde Terraform ile kodlanmıştır.
