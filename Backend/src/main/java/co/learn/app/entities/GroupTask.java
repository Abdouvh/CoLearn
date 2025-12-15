package co.learn.app.entities;

import jakarta.persistence.*;

/**
 * Entité représentant une tâche à accomplir au sein d'un groupe.
 * <p>
 * Utilisée dans le tableau de bord collaboratif (Kanban).
 * Statuts possibles : TODO, DOING, DONE.
 */
@Entity
@Table(name = "group_tasks")
public class GroupTask {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;
    private String status; // TODO, DOING, DONE

    @ManyToOne
    @JoinColumn(name = "group_id")
    private StudyGroup group;

    public GroupTask() {
    }

    public GroupTask(String title, String status, StudyGroup group) {
        this.title = title;
        this.status = status;
        this.group = group;
    }

    public Long getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public StudyGroup getGroup() {
        return group;
    }

    public void setGroup(StudyGroup group) {
        this.group = group;
    }
}
