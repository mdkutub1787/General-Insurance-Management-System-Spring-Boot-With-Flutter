package com.kutub.InsuranceManagement.restcontroller;


import com.kutub.InsuranceManagement.entity.MarineInsuranceBill;
import com.kutub.InsuranceManagement.service.MarineInsuranceBillService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("api/marinebill")
@CrossOrigin(origins = "http://localhost:4200/")
public class MarineInsuranceBillController {

    @Autowired
    private MarineInsuranceBillService marineInsuranceBillService ;


    @GetMapping("/")
    public List<MarineInsuranceBill> getAllBills() {
        return marineInsuranceBillService.getAllMarineInsuranceBills();
    }

    @PostMapping("/save")
    public void saveMarineInsuranceBill(@RequestBody MarineInsuranceBill mb) {
        marineInsuranceBillService.saveMarineInsuranceBill(mb);
    }

    @PutMapping("/update/{id}")
    public  void updateMarineInsuranceBill(@RequestBody MarineInsuranceBill mb){
        marineInsuranceBillService.saveMarineInsuranceBill(mb);
    }

    @DeleteMapping("/delete/{id}")
    public void deleteMarineInsuranceBillById(@PathVariable long id) {
        marineInsuranceBillService.deleteMarineInsuranceBill(id);
    }

    // Get bill by ID
    @GetMapping("/{id}")
    public ResponseEntity<MarineInsuranceBill> getMarineInsuranceBillById(@PathVariable int id) {
        MarineInsuranceBill mb = marineInsuranceBillService.getMarineInsuranceBillById(id);
        return ResponseEntity.ok(mb);
    }
}
