package com.kutub.InsuranceManagement.restcontroller;

import com.kutub.InsuranceManagement.entity.AuthenticationResponse;
import com.kutub.InsuranceManagement.entity.Token;
import com.kutub.InsuranceManagement.entity.User;
import com.kutub.InsuranceManagement.repository.TokenRepository;
import com.kutub.InsuranceManagement.service.AuthService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@AllArgsConstructor
@CrossOrigin(origins = "http://localhost:4200/")
public class AuthenticalController {

    private final AuthService authService;
    private final TokenRepository tokenRepository;

    @PostMapping("/register")
    public ResponseEntity<AuthenticationResponse> register(
            @RequestBody User request
    ) {
        return ResponseEntity.ok(authService.register(request));
    }

    @PostMapping("/register/admin")
    public ResponseEntity<AuthenticationResponse> registerAdmin(
            @RequestBody User request
    ) {
        return ResponseEntity.ok(authService.registerAdmin(request));
    }

    @PostMapping("/register/bill")
    public ResponseEntity<AuthenticationResponse> registerBill(
            @RequestBody User request
    ) {
        return ResponseEntity.ok(authService.registerBill(request));
    }


    @PostMapping("/login")
    public ResponseEntity<AuthenticationResponse> login(
            @RequestBody User request
    ) {
        return ResponseEntity.ok(authService.authenticate(request));
    }


    @GetMapping("/activate/{id}")
    public ResponseEntity<String> activateUser(@PathVariable("id") int id) {
        String response = authService.activateUser(id);
        return ResponseEntity.ok(response);
    }



}
