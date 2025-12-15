package co.learn.app.repositories;

import co.learn.app.entities.Comment;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

/**
 * Interface d'accès aux données pour les commentaires des cours.
 */
public interface CommentRepository extends JpaRepository<Comment, Long> {
    List<Comment> findByCourse_IdOrderByCreatedAtDesc(Long courseId);
}
