package co.learn.app.controllers;

import co.learn.app.entities.Comment;
import co.learn.app.entities.Course;
import co.learn.app.entities.User;
import co.learn.app.repositories.CommentRepository;
import co.learn.app.repositories.CourseRepository;
import co.learn.app.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/comments")
@CrossOrigin(origins = "*")
public class CommentController {

    @Autowired
    private CommentRepository commentRepository;

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/course/{courseId}")
    public List<Comment> getCourseComments(@PathVariable Long courseId) {
        return commentRepository.findByCourse_IdOrderByCreatedAtDesc(courseId);
    }

    @PostMapping("/course/{courseId}")
    public ResponseEntity<?> addComment(@PathVariable Long courseId, @RequestBody Map<String, Object> payload) {
        String content = (String) payload.get("content");
        Long userId = ((Number) payload.get("userId")).longValue();

        if (content == null || content.isEmpty()) {
            return ResponseEntity.badRequest().body("Content cannot be empty");
        }

        Course course = courseRepository.findById(courseId).orElse(null);
        User user = userRepository.findById(userId).orElse(null);

        if (course == null || user == null) {
            return ResponseEntity.badRequest().body("Course or User not found");
        }

        Comment comment = new Comment();
        comment.setContent(content);
        comment.setCourse(course);
        comment.setAuthor(user);
        comment.setCreatedAt(LocalDateTime.now());

        return ResponseEntity.ok(commentRepository.save(comment));
    }
}
