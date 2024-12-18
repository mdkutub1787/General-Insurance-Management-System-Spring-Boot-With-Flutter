package com.kutub.InsuranceManagement.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Calendar;
import java.util.Date;
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
    @Temporal(TemporalType.DATE)
    private Date date = new Date();

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
    @Temporal(TemporalType.DATE)
    private Date periodFrom;

    @Column(nullable = false)
    @Temporal(TemporalType.DATE)
    private Date periodTo;

    @JsonIgnore
    @OneToMany(mappedBy = "policy", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<Bill> bills;

    // Custom setter for periodFrom
    public void setPeriodFrom(Date periodFrom) {
        this.periodFrom = periodFrom;
        setPeriodToAutomatically();
    }

    // Automatically sets periodTo to one year after periodFrom
    private void setPeriodToAutomatically() {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(this.periodFrom);
        calendar.add(Calendar.YEAR, 1);
        this.periodTo = calendar.getTime();
    }
}
