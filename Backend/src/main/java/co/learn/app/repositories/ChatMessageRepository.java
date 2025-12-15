package co.learn.app.repositories;

import co.learn.app.entities.ChatMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

/**
 * Interface d'accès aux données pour les messages de chat de groupe.
 */
public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long> {
    List<ChatMessage> findByGroupIdOrderByTimestampAsc(Long groupId);
}
