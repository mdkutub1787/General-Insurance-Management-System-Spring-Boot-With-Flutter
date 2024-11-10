package com.kutub.InsuranceManagement.restcontroller;

import com.kutub.InsuranceManagement.entity.Bill;
import com.kutub.InsuranceManagement.entity.MoneyReceipt;
import com.kutub.InsuranceManagement.entity.Policy;
import com.kutub.InsuranceManagement.service.MoneyReceiptService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("api/moneyreceipt")
@CrossOrigin(origins = "http://localhost:4200/")

public class MoneyReceiptController {
    
    @Autowired
    private MoneyReceiptService moneyReceiptService;

    // Get all Receipt
    @GetMapping("/")
    public List<MoneyReceipt> getAllMoneyReceipt() {
        return moneyReceiptService.getAllMoneyReceipt();
    }


    // Create a new Receipt
    @PostMapping("/save")
    public void saveMoneyReceipt(@RequestBody MoneyReceipt mr) {
        moneyReceiptService.saveMoneyReceipt(mr);
    }


    @PutMapping("/update/{id}")
    public ResponseEntity<String> updateMoneyReceipt(@PathVariable int id, @RequestBody MoneyReceipt mr) {
        try {
            moneyReceiptService.updateMoneyReceipt(mr, id);
            return ResponseEntity.ok("Money  Receipt updated successfully.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }



    // Delete a Receipt by ID
    @DeleteMapping("/delete/{id}")
    public void deleteMoneyReceiptById(@PathVariable int id) {
        moneyReceiptService.deleteMoneyReceipt(id);
    }


    @GetMapping("/{id}")
    public ResponseEntity<MoneyReceipt> getMoneyReceiptById(@PathVariable int id) {
        MoneyReceipt mr = moneyReceiptService.getMoneyReceiptById(id);
        return ResponseEntity.ok(mr);
    }


}
