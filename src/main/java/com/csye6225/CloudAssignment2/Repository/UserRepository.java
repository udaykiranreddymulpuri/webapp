package com.csye6225.CloudAssignment2.Repository;

import com.csye6225.CloudAssignment2.Model.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
    User findByEmail(String email);
}
