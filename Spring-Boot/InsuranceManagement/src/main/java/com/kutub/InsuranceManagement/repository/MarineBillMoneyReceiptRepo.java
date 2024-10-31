package com.kutub.InsuranceManagement.repository;

import com.kutub.InsuranceManagement.entity.MarineBillMoneyReceipt;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MarineBillMoneyReceiptRepo extends JpaRepository<MarineBillMoneyReceipt,Long> {
}
