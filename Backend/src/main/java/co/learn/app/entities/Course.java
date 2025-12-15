package co.learn.app.entities;

import jakarta.persistence.*;
import lombok.Data;
import java.util.List;

/**
 * Entité représentant un Cours dans la plateforme LMS.
 * <p>
 * Cette classe gère les métadonnées du cours, son contenu (modules),
 * ainsi que les statistiques d'engagement (inscriptions, notes).
 * Elle supporte à la fois les cours créés manuellement et ceux générés par
 * l'IA.
 */
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

    /** Indique si l'utilisateur a complété ce cours. */
    private boolean isCompleted = false;

    /** Indique si le contenu a été généré via l'IA Gemini. */
    private boolean aiGenerated = false;

    @ManyToOne
    private User creator;

    @ManyToOne
    private User originalCreator; // The actual professor, preserved during cloning

    // STATS
    private int enrolledCount = 0;
    private double averageRating = 0.0;
    private int ratingCount = 0;

    /** Lien vers le cours parent pour l'agrégation des statistiques globales. */
    private Long originalCourseId;
}
