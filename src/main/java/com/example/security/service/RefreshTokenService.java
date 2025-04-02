package com.example.security.service;

import com.example.security.entity.RefreshToken;
import com.example.security.entity.User;
import com.example.security.repository.RefreshTokenRepository;
import com.example.security.repository.UserRepository;
import com.example.security.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class RefreshTokenService {
    private final RefreshTokenRepository refreshTokenRepository;
    private final UserRepository userRepository;
    private final JwtTokenProvider jwtTokenProvider;

    public String createRefreshToken(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        String token = jwtTokenProvider.generateRefreshToken(username);

        RefreshToken refreshToken = RefreshToken.builder()
                .token(token)
                .expiryDate(new Date(System.currentTimeMillis() + jwtTokenProvider.getRefreshTokenExpiration()))
                .user(user)
                .build();

        refreshTokenRepository.save(refreshToken);
        return token;
    }

    @Transactional
    public String refreshAccessToken(String refreshToken) {
        Optional<RefreshToken> storedToken = refreshTokenRepository.findByToken(refreshToken);

        if (storedToken.isEmpty() || storedToken.get().getExpiryDate().before(new Date())) {
            storedToken.ifPresent(refreshTokenRepository::delete);
            throw new RuntimeException("Invalid or expired refresh token");
        }


        String username = jwtTokenProvider.getUsername(refreshToken);
        return jwtTokenProvider.generateAccessToken(username);
    }

}
