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

    @PostMapping("/logout")
    public ResponseEntity<String> logout(@RequestHeader("Authorization") String authorizationHeader) {
        // Check if the authorization header is missing or invalid
        if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid or missing token.");
        }

        // Extract the token from the authorization header
        String token = authorizationHeader.replace("Bearer ", "").trim();

        // Find the token in the repository
        Optional<Token> storedTokenOpt = tokenRepository.findByToken(token);
        if (storedTokenOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Token not found or already invalidated.");
        }

        Token storedToken = storedTokenOpt.get();

        // Check if the token is already logged out
        if (storedToken.isLoggedOut()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Token already logged out.");
        }

        // Mark the token as logged out
        storedToken.setLoggedOut(true);
        tokenRepository.save(storedToken);

        // Revoke all other tokens for the user (if necessary)
        authService.revokeAllTokenByUser(storedToken.getUser());

        // Return success message
        return ResponseEntity.ok("Logout successful, token invalidated.");
    }



}
