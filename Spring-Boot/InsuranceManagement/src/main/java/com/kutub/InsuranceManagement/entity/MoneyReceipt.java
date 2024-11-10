package com.kutub.InsuranceManagement.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "moneyreceipts")
public class MoneyReceipt {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String issuingOffice;

    private String classOfInsurance;

    @Column(nullable = false)
    @Temporal(TemporalType.DATE)
    private Date date = new Date(); 

    private String modeOfPayment;
  
    private String issuedAgainst;



    @ManyToOne(fetch = FetchType.EAGER, cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinColumn(name = "billId")
    private Bill bill;


}
