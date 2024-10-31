package com.kutub.InsuranceManagement.repository;


import com.kutub.InsuranceManagement.entity.MoneyReceipt;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MoneyReceiptRepository extends JpaRepository<MoneyReceipt, Integer> {
}
