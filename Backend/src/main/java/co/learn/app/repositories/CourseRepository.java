package co.learn.app.repositories;

import co.learn.app.entities.Course;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

/**
 * Interface d'accès aux données pour les cours.
 * <p>
 * Permet la recherche par créateur, rôle, titre (pour les cours originaux) et
 * lien de parentalité.
 */
public interface CourseRepository extends JpaRepository<Course, Long> {
    List<Course> findByCreator_Id(Long userId);

    List<Course> findByCreator_Role(String role);

    List<Course> findByTitleContainingIgnoreCaseAndOriginalCourseIdIsNull(String title); // Search ONLY original courses

    Course findByCreator_IdAndOriginalCourseId(Long userId, Long originalCourseId);
}