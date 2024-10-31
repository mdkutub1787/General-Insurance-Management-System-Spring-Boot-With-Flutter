package com.kutub.InsuranceManagement.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;
import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "marineInsuranceDetails")
public class MarineInsuranceDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @Column(nullable = false)
    @Temporal(TemporalType.DATE)
    private Date date = new Date();

    @Column(nullable = false)
    private String bankName;

    @Column(nullable = false)
    private String policyholder;

    @Column(nullable = false)
    private String address;

    @Column(nullable = false)
    private String voyageFrom;

    @Column(nullable = false)
    private String voyageTo;

    @Column(nullable = false)
    private String via;

    @Column(nullable = false)
    private String stockItem;

    @Positive(message = "Sum insured in USD must be positive")
    @Column(nullable = false)
    private double sumInsuredUsd;

    @Column(nullable = false)
    private double usdRate;

    @Column(nullable = false)
    private double sumInsured;

    @Column(nullable = false)
    private String coverage;

    @JsonIgnore
    @OneToMany(mappedBy = "marineDetails", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<MarineInsuranceBill> marineInsuranceBills;

    public void convertSumInsuredUsd(double exchangeRate) {
        this.sumInsured = this.sumInsuredUsd * exchangeRate;
        this.usdRate = exchangeRate;
    }
}
