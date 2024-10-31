package com.kutub.InsuranceManagement.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "policies")
public class Policy {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false)
    private String date;

    @Column(nullable = false)
    private String bankName;

    @Column(nullable = false)
    private String policyholder;

    @Column(nullable = false)
    private String address;

    @Column(nullable = false)
    private String stockInsured;

    @Column(nullable = false)
    private double sumInsured;

    @Column(nullable = false)
    private String interestInsured;

    @Column(nullable = false)
    private String coverage;

    @Column(nullable = false)
    private String location;

    @Column(nullable = false)
    private String construction;

    @Column(nullable = false)
    private String owner;

    @Column(nullable = false)
    private String usedAs;

    @Column(nullable = false)
    private String periodFrom;

    @Column(nullable = false)
    private String periodTo;

    @JsonIgnore
    @OneToMany(mappedBy = "policy", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<Bill> bills;

    // Custom setter for periodFrom
    public void setPeriodFrom(String periodFrom) {
        this.periodFrom = periodFrom;
        setPeriodToAutomatically();
    }

    // Automatically sets periodTo to one year after periodFrom
    private void setPeriodToAutomatically() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate fromDate = LocalDate.parse(this.periodFrom, formatter);
        this.periodTo = fromDate.plusYears(1).format(formatter);
    }
}
