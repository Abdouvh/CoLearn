package co.learn.app.entities;

import jakarta.persistence.*;
import lombok.Data;
import java.util.List;

@Entity
@Data
@Table(name = "courses")
public class Course {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;
    @Column(columnDefinition = "TEXT")
    private String description;
    private String language; // "fr" or "en"
    private String level; // "Débutant", etc.
    private String icon; // e.g. "code", "business"
    private String category; // e.g. "Data Science", "Design"

    @OneToMany(cascade = CascadeType.ALL)
    private List<Module> modules;

    private boolean isCompleted = false; // Tracks if the course is fully finished

    @ManyToOne
    private User creator;
}
