package com.kutub.InsuranceManagement.restcontroller;

import com.kutub.InsuranceManagement.entity.Bill;
import com.kutub.InsuranceManagement.service.BillService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("api/bill")
@CrossOrigin(origins = "http://localhost:4200/")
public class BillController {

    @Autowired
    private BillService billService;

    // Get all bills
    @GetMapping("/")
    public ResponseEntity<List<Bill>> getAllBills() {
        List<Bill> bills = billService.getAllBill();
        return ResponseEntity.ok(bills);
    }

    // Save a new bill
    @PostMapping("/save")
    public ResponseEntity<String> saveBill(@RequestBody Bill b) {
        try {
            billService.saveBill(b);
            return ResponseEntity.status(HttpStatus.CREATED).body("Bill saved successfully.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    // Update an existing bill
    @PutMapping("/update/{id}")
    public ResponseEntity<String> updateBill(@PathVariable int id, @RequestBody Bill b) {
        try {
            billService.updateBill(b, id);
            return ResponseEntity.ok("Bill updated successfully.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

    // Delete a bill by ID
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<String> deleteBillById(@PathVariable int id) {
        try {
            billService.deleteBill(id);
            return ResponseEntity.ok("Bill deleted successfully.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

    // Get bill by ID
    @GetMapping("/{id}")
    public ResponseEntity<Bill> getBillById(@PathVariable int id) {
        try {
            Bill bill = billService.getBillById(id);
            return ResponseEntity.ok(bill);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

    // Search bills by policyholder name
    @GetMapping("/searchpolicyholder")
    public ResponseEntity<List<Bill>> getBillsByPolicyholder(@RequestParam String policyholder) {
        List<Bill> bills = billService.getBillsByPolicyholder(policyholder);
        return ResponseEntity.ok(bills);
    }

    // Search bills by policy ID
    @GetMapping("/searchpolicyid")
    public ResponseEntity<List<Bill>> findBillsByPolicyId(@RequestParam("policyid") int policyid) {
        List<Bill> bills = billService.findBillByPolicyId(policyid);
        return ResponseEntity.ok(bills);
    }
}
