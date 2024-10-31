package com.kutub.InsuranceManagement.service;

import com.kutub.InsuranceManagement.entity.Bill;
import com.kutub.InsuranceManagement.entity.MoneyReceipt;
import com.kutub.InsuranceManagement.repository.BillRepository;
import com.kutub.InsuranceManagement.repository.MoneyReceiptRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MoneyReceiptService {

    @Autowired
    private MoneyReceiptRepository moneyReceiptRepository;

    @Autowired
    private BillRepository billRepository;

    public List<MoneyReceipt> getAllMoneyReceipt() {
        return  moneyReceiptRepository.findAll();
    }

    public void saveMoneyReceipt(MoneyReceipt mr) {
            Bill bill = billRepository.findById(mr.getBill().getId())
                    .orElseThrow(
                            () -> new RuntimeException("Bill not found " + mr.getBill().getId())
                    );
            mr.setBill(bill);
            moneyReceiptRepository.save(mr);
        }


    public MoneyReceipt getMoneyReceiptById(int id) {
        return moneyReceiptRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("MoneyReceipt not found with ID: " + id));
    }

    public void deleteMoneyReceipt(int id) {
        moneyReceiptRepository.deleteById(id);
    }

    public void updateMoneyReceipt(MoneyReceipt mr, int id) {
        moneyReceiptRepository.save(mr);

    }



}
