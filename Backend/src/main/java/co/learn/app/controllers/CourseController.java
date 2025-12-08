package co.learn.app.controllers;

import co.learn.app.entities.Course;
import co.learn.app.entities.Module;
import co.learn.app.repositories.CourseRepository;
import co.learn.app.repositories.ModuleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity; // Required
import org.springframework.transaction.annotation.Transactional; // Required
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/courses")
@CrossOrigin(origins = "*")
public class CourseController {

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private ModuleRepository moduleRepository;

    @PostMapping("/generate")
    public Course generateCourse(@RequestBody Map<String, String> request) {
        String topic = request.get("topic");
        String lang = request.get("language");
        String level = request.get("level");

        Course course = new Course();
        course.setTitle(topic);
        course.setLevel(level);
        course.setLanguage(lang);
        course.setIcon("school");

        List<Module> modules = new ArrayList<>();

        if ("fr".equals(lang)) {
            // French Template
            course.setDescription("Un cours complet pour maîtriser " + topic + ".");

            Module m1 = new Module();
            m1.setTitle("Introduction à " + topic);
            m1.setContent("Bienvenue ! Dans ce module, nous allons couvrir les bases de " + topic + "...");
            m1.setLocked(false); // Unlocked by default
            modules.add(m1);

            Module m2 = new Module();
            m2.setTitle("Concepts Avancés");
            m2.setContent("Approfondissons vos connaissances sur " + topic + "...");
            m2.setLocked(true); // Locked initially
            modules.add(m2);

            Module quiz = new Module();
            quiz.setTitle("Quiz Final");
            quiz.setContent("Question 1: Quel est le but de " + topic + "?");
            quiz.setLocked(true);
            modules.add(quiz);

        } else {
            // English Template
            course.setDescription("A complete guide to mastering " + topic + ".");

            Module m1 = new Module();
            m1.setTitle("Introduction to " + topic);
            m1.setContent("Welcome! In this module, we will cover the basics of " + topic + "...");
            m1.setLocked(false);
            modules.add(m1);

            Module m2 = new Module();
            m2.setTitle("Advanced Concepts");
            m2.setContent("Let's dive deeper into " + topic + "...");
            m2.setLocked(true);
            modules.add(m2);

            Module quiz = new Module();
            quiz.setTitle("Final Quiz");
            quiz.setContent("Question 1: What is the main goal of " + topic + "?");
            quiz.setLocked(true);
            modules.add(quiz);
        }

        course.setModules(modules);
        return courseRepository.save(course);
    }

    @GetMapping
    public List<Course> getAllCourses() {
        return courseRepository.findAll();
    }

    // --- FIX: SAVING PROGRESS ---
    @PutMapping("/modules/{id}/unlock")
    @Transactional // <--- CRITICAL: Forces DB to save the change
    public ResponseEntity<?> unlockModule(@PathVariable Long id) {
        System.out.println(">>> SAVING: Unlocking Module ID " + id);

        return moduleRepository.findById(id).map(module -> {
            module.setLocked(false); // Unlock it
            moduleRepository.save(module); // Save it
            return ResponseEntity.ok().build();
        }).orElseGet(() -> {
            return ResponseEntity.notFound().build();
        });
    }
}