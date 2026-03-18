package com.kindopslab.appjava.web;

import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthController {

  @GetMapping("/health")
  public Map<String, String> health() {
    return Map.of("status", "ok");
  }

  @GetMapping("/greet/{name}")
  public Map<String, String> greet(@PathVariable("name") String name) {
    return Map.of("message", "hello, " + name);
  }
}
